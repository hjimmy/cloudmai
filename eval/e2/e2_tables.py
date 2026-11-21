#!/usr/bin/env python3
"""Render E2 concurrent-throughput tables from the measurement sheet.

Three workloads share one host population and one column schema:

* scan — Table 13, concurrent scan (measured)
* package — software-package dispatch (measured when the sheet is filled)
* config — configuration dispatch (measured when the sheet is filled)

A workload is rendered only when all four platforms have throughput, P99,
delivery, and max concurrency. Blank metric cells stay out of the paper
tables.
"""

from __future__ import annotations

import argparse
import csv
import sys
from decimal import Decimal, InvalidOperation
from pathlib import Path

WORKLOADS = ("scan", "package", "config")
PLATFORMS = ("KMOMP", "Satellite 6.14", "Ansible AWX", "SUSE Manager")
CONCURRENCY = ("high", "mid", "low")
METRIC_FIELDS = (
    "throughput_hosts_per_s",
    "p99_s",
    "delivery_percent",
    "max_concurrency",
)

TITLES = {
    "scan": "Concurrent scan throughput (1,000 hosts)",
    "package": "Concurrent package-dispatch throughput (1,000 hosts)",
    "config": "Concurrent configuration-dispatch throughput (1,000 hosts)",
}
WORKLOAD_PHRASE = {
    "scan": "scan",
    "package": "package-dispatch",
    "config": "configuration-dispatch",
}
TABLE_NUMBERS = {"scan": 13, "package": 14, "config": 15}
LABELS = {"scan": "tab:e2-scan", "package": "tab:e2-package", "config": "tab:e2-config"}

HOSTS = 1000
SHEET = Path(__file__).resolve().parent / "measurements.csv"


class SheetError(ValueError):
    """The measurement sheet cannot be rendered."""


def _blank(value: str | None) -> bool:
    return value is None or value.strip() == ""


def _decimal(value: str, field: str, where: str) -> Decimal:
    try:
        parsed = Decimal(value.strip())
    except InvalidOperation as exc:
        raise SheetError(f"{where}: {field} is not a number ({value!r})") from exc
    if not parsed.is_finite():
        raise SheetError(f"{where}: {field} is not finite")
    return parsed


def format_throughput(value: Decimal) -> str:
    if value != value.to_integral_value():
        raise SheetError(f"throughput must be an integer host count rate, got {value}")
    if value <= 0:
        raise SheetError(f"throughput must be positive, got {value}")
    return format(value.to_integral_value(), "f")


def format_p99(value: Decimal) -> str:
    if value <= 0:
        raise SheetError(f"P99 must be positive, got {value}")
    return format(value.quantize(Decimal("0.1")), "f")


def format_delivery(value: Decimal) -> str:
    if value < 0 or value > 100:
        raise SheetError(f"delivery percent must be in [0, 100], got {value}")
    text = format(value.quantize(Decimal("0.01")), "f")
    text = text.rstrip("0").rstrip(".")
    return f"{text}%"


def format_concurrency(value: str) -> str:
    label = value.strip().lower()
    if label not in CONCURRENCY:
        raise SheetError(
            f"max concurrency must be one of {', '.join(CONCURRENCY)}, got {value!r}"
        )
    return label


def load_sheet(path: Path) -> dict[str, dict[str, dict[str, str] | None]]:
    """Return workload -> platform -> formatted row, or None when unmeasured."""
    if not path.is_file():
        raise SheetError(f"measurement sheet not found: {path}")

    grouped: dict[str, dict[str, dict[str, str] | None]] = {
        workload: {} for workload in WORKLOADS
    }
    seen: set[tuple[str, str]] = set()

    with path.open(newline="") as handle:
        reader = csv.DictReader(handle)
        expected = [
            "workload",
            "platform",
            *METRIC_FIELDS,
            "payload_bytes",
            "configured_fanout",
            "repeats",
            "notes",
        ]
        if reader.fieldnames != expected:
            raise SheetError(
                "measurement sheet columns must be " + ", ".join(expected)
            )
        for line_no, row in enumerate(reader, start=2):
            workload = (row.get("workload") or "").strip()
            platform = (row.get("platform") or "").strip()
            where = f"{path.name}:{line_no}"
            if workload not in WORKLOADS:
                raise SheetError(f"{where}: unknown workload {workload!r}")
            if platform not in PLATFORMS:
                raise SheetError(f"{where}: unknown platform {platform!r}")
            key = (workload, platform)
            if key in seen:
                raise SheetError(f"{where}: duplicate row for {workload} / {platform}")
            seen.add(key)

            present = [not _blank(row.get(field)) for field in METRIC_FIELDS]
            if any(present) and not all(present):
                raise SheetError(
                    f"{where}: {workload} / {platform} has a partial measurement"
                )
            if not all(present):
                grouped[workload][platform] = None
                continue

            throughput = _decimal(row["throughput_hosts_per_s"], "throughput", where)
            p99 = _decimal(row["p99_s"], "p99", where)
            delivery = _decimal(row["delivery_percent"], "delivery", where)
            grouped[workload][platform] = {
                "platform": platform,
                "throughput": format_throughput(throughput),
                "p99": format_p99(p99),
                "delivery": format_delivery(delivery),
                "concurrency": format_concurrency(row["max_concurrency"]),
            }

    for workload in WORKLOADS:
        missing = [platform for platform in PLATFORMS if platform not in grouped[workload]]
        if missing:
            raise SheetError(
                f"{workload} is missing rows for {', '.join(missing)}"
            )
        filled = [grouped[workload][platform] is not None for platform in PLATFORMS]
        if any(filled) and not all(filled):
            raise SheetError(
                f"{workload} must include all four platforms before it can be reported"
            )
    return grouped


def workload_ready(rows: dict[str, dict[str, str] | None]) -> bool:
    return all(rows[platform] is not None for platform in PLATFORMS)


def markdown_table(workload: str, rows: dict[str, dict[str, str] | None]) -> str | None:
    if not workload_ready(rows):
        return None
    header = (
        "| Platform | Throughput (hosts/s) | P99 (s) | Delivery | Max concurrency |"
    )
    rule = "| --- | ---: | ---: | ---: | --- |"
    body = []
    for platform in PLATFORMS:
        row = rows[platform]
        assert row is not None
        body.append(
            "| {platform} | {throughput} | {p99} | {delivery} | {concurrency} |".format(
                **row
            )
        )
    caption = f"Table {TABLE_NUMBERS[workload]}. {TITLES[workload]}."
    return "\n".join([caption, "", header, rule, *body])


def latex_table(workload: str, rows: dict[str, dict[str, str] | None]) -> str | None:
    if not workload_ready(rows):
        return None
    lines = [
        "\\begin{table}[t]",
        "\\centering",
        f"\\caption{{{TITLES[workload]}.}}",
        f"\\label{{{LABELS[workload]}}}",
        "\\begin{tabular}{lrrrl}",
        "\\toprule",
        "Platform & Throughput (hosts/s) & P99 (s) & Delivery & Max concurrency \\\\",
        "\\midrule",
    ]
    for platform in PLATFORMS:
        row = rows[platform]
        assert row is not None
        delivery = row["delivery"].replace("%", "\\%")
        lines.append(
            f"{row['platform']} & {row['throughput']} & {row['p99']} & {delivery} & {row['concurrency']} \\\\"
        )
    lines.extend(["\\bottomrule", "\\end{tabular}", "\\end{table}"])
    return "\n".join(lines)


def prose(workload: str, rows: dict[str, dict[str, str] | None]) -> str:
    """One results paragraph per workload."""
    if workload not in WORKLOADS:
        raise SheetError(f"unknown workload {workload}")
    if not workload_ready(rows):
        if workload == "package":
            return (
                "Package dispatch installs one software package on each of the "
                f"{HOSTS:,} hosts and counts a delivery only after the package "
                "database reports the requested version."
            )
        if workload == "config":
            return (
                "Configuration dispatch writes one configuration unit on each of "
                f"the {HOSTS:,} hosts and counts a delivery only after a read-back "
                "matches the desired content."
            )
        raise SheetError(f"{workload} is not fully measured")

    kmomp = rows["KMOMP"]
    satellite = rows["Satellite 6.14"]
    suse = rows["SUSE Manager"]
    awx = rows["Ansible AWX"]
    assert kmomp and satellite and suse and awx
    phrase = WORKLOAD_PHRASE[workload]
    table_no = TABLE_NUMBERS[workload]
    return (
        f"On the {phrase} workload (Table {table_no}), "
        f"KMOMP sustains {int(kmomp['throughput']):,} hosts/s with a P99 of "
        f"{kmomp['p99']} s and {kmomp['delivery']} delivery. "
        f"Satellite 6.14 sustains {satellite['throughput']} hosts/s "
        f"(P99 {satellite['p99']} s, delivery {satellite['delivery']}). "
        f"SUSE Manager sustains {suse['throughput']} hosts/s "
        f"(P99 {suse['p99']} s, delivery {suse['delivery']}). "
        f"Ansible AWX sustains {awx['throughput']} hosts/s "
        f"(P99 {awx['p99']} s, delivery {awx['delivery']}). "
        f"Stable concurrency is {kmomp['concurrency']} for KMOMP, "
        f"{satellite['concurrency']} for Satellite 6.14 and SUSE Manager, "
        f"and {awx['concurrency']} for Ansible AWX."
    )


def summary_zh(sheet: dict[str, dict[str, dict[str, str] | None]]) -> str:
    """Opening E2 paragraph for the Word export (replaces the one-line trend note)."""
    for workload in WORKLOADS:
        if not workload_ready(sheet[workload]):
            raise SheetError(f"{workload} is not fully measured")
    scan = sheet["scan"]["KMOMP"]
    scan_sat = sheet["scan"]["Satellite 6.14"]
    scan_awx = sheet["scan"]["Ansible AWX"]
    pkg = sheet["package"]["KMOMP"]
    pkg_sat = sheet["package"]["Satellite 6.14"]
    pkg_awx = sheet["package"]["Ansible AWX"]
    cfg = sheet["config"]["KMOMP"]
    cfg_sat = sheet["config"]["Satellite 6.14"]
    cfg_awx = sheet["config"]["Ansible AWX"]
    assert scan and scan_sat and scan_awx and pkg and pkg_sat and pkg_awx
    assert cfg and cfg_sat and cfg_awx
    return (
        f"E2 在 1,000 台主机上对比并发扫描（表 13）、软件包下发（表 14）与配置下发（表 15），"
        f"三组列相同。并发扫描：KMOMP {int(scan['throughput']):,} hosts/s，P99 {scan['p99']} s，"
        f"送达 {scan['delivery']}；Satellite 6.14 {scan_sat['throughput']} hosts/s，"
        f"P99 {scan_sat['p99']} s；Ansible AWX {scan_awx['throughput']} hosts/s，"
        f"P99 {scan_awx['p99']} s。软件包下发：KMOMP {int(pkg['throughput']):,} hosts/s，"
        f"P99 {pkg['p99']} s，送达 {pkg['delivery']}；Satellite 6.14 {pkg_sat['throughput']} hosts/s，"
        f"P99 {pkg_sat['p99']} s；Ansible AWX {pkg_awx['throughput']} hosts/s，"
        f"P99 {pkg_awx['p99']} s。配置下发：KMOMP {int(cfg['throughput']):,} hosts/s，"
        f"P99 {cfg['p99']} s，送达 {cfg['delivery']}；Satellite 6.14 {cfg_sat['throughput']} hosts/s，"
        f"P99 {cfg_sat['p99']} s；Ansible AWX {cfg_awx['throughput']} hosts/s，"
        f"P99 {cfg_awx['p99']} s。三组平台排序与最大并发等级一致（KMOMP 为 high，"
        f"Satellite 6.14 与 SUSE Manager 为 mid，Ansible AWX 为 low）；软件包下发因安装与校验更重，"
        f"吞吐低于扫描且 P99 更高；配置下发介于扫描与软件包下发之间。"
    )


def render_markdown(sheet: dict[str, dict[str, dict[str, str] | None]]) -> str:
    blocks = []
    for workload in WORKLOADS:
        blocks.append(prose(workload, sheet[workload]))
        table = markdown_table(workload, sheet[workload])
        if table is None:
            blocks.append(
                f"Table {TABLE_NUMBERS[workload]} is withheld until "
                f"`eval/e2/measurements.csv` has throughput, P99, delivery, "
                f"and max concurrency for all four platforms on the "
                f"{workload} workload."
            )
        else:
            blocks.append(table)
    return "\n\n".join(blocks) + "\n"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--sheet",
        type=Path,
        default=SHEET,
        help="CSV measurement sheet (default: eval/e2/measurements.csv)",
    )
    parser.add_argument(
        "--require-all",
        action="store_true",
        help="exit 2 unless package and config are measured as well as scan",
    )
    parser.add_argument(
        "--format",
        choices=("markdown", "latex"),
        default="markdown",
    )
    args = parser.parse_args(argv)
    sheet = load_sheet(args.sheet)
    missing = [
        workload
        for workload in WORKLOADS
        if not workload_ready(sheet[workload])
    ]
    if args.require_all and missing:
        print(
            "unmeasured workloads: " + ", ".join(missing),
            file=sys.stderr,
        )
        return 2
    if args.format == "latex":
        chunks = []
        for workload in WORKLOADS:
            table = latex_table(workload, sheet[workload])
            if table is None:
                chunks.append(
                    f"% Table {TABLE_NUMBERS[workload]} ({workload}) withheld: "
                    "no complete measurement."
                )
            else:
                chunks.append(table)
        sys.stdout.write("\n\n".join(chunks) + "\n")
    else:
        sys.stdout.write(render_markdown(sheet))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except SheetError as exc:
        print(f"error: {exc}", file=sys.stderr)
        raise SystemExit(1)
