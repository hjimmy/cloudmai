#!/usr/bin/env python3
"""Checks for the E2 scan, package, and configuration throughput tables."""

from __future__ import annotations

import subprocess
import sys
import tempfile
import unittest
import zipfile
from decimal import Decimal
from pathlib import Path
from xml.etree import ElementTree as ET

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(Path(__file__).resolve().parent))

import e2_tables  # noqa: E402

DOC = ROOT / "docs" / "evaluation" / "e2-concurrent-throughput.md"
DOCX = ROOT / "docs" / "evaluation" / "e2-concurrent-throughput.docx"
SHEET = Path(__file__).resolve().parent / "measurements.csv"
W_T = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}t"
W_TBL = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}tbl"
W_TR = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}tr"

SCAN_TABLE = """\
Table 13. Concurrent scan throughput (1,000 hosts).

| Platform | Throughput (hosts/s) | P99 (s) | Delivery | Max concurrency |
| --- | ---: | ---: | ---: | --- |
| KMOMP | 1847 | 2.8 | 99.99% | high |
| Satellite 6.14 | 312 | 12.0 | 99.8% | mid |
| Ansible AWX | 89 | 45.0 | 99.5% | low |
| SUSE Manager | 276 | 14.5 | 99.7% | mid |
"""

PACKAGE_TABLE = """\
Table 14. Concurrent package-dispatch throughput (1,000 hosts).

| Platform | Throughput (hosts/s) | P99 (s) | Delivery | Max concurrency |
| --- | ---: | ---: | ---: | --- |
| KMOMP | 1065 | 3.8 | 99.98% | high |
| Satellite 6.14 | 181 | 16.5 | 99.7% | mid |
| Ansible AWX | 51 | 61.0 | 99.4% | low |
| SUSE Manager | 160 | 20.0 | 99.6% | mid |
"""

CONFIG_TABLE = """\
Table 15. Concurrent configuration-dispatch throughput (1,000 hosts).

| Platform | Throughput (hosts/s) | P99 (s) | Delivery | Max concurrency |
| --- | ---: | ---: | ---: | --- |
| KMOMP | 1440 | 3.5 | 99.99% | high |
| Satellite 6.14 | 243 | 15.0 | 99.8% | mid |
| Ansible AWX | 70 | 56.0 | 99.5% | low |
| SUSE Manager | 215 | 18.0 | 99.7% | mid |
"""


class FormatTests(unittest.TestCase):
    def test_delivery_matches_table_13_style(self) -> None:
        self.assertEqual(e2_tables.format_delivery(Decimal("99.99")), "99.99%")
        self.assertEqual(e2_tables.format_delivery(Decimal("99.8")), "99.8%")
        self.assertEqual(e2_tables.format_delivery(Decimal("99.98")), "99.98%")
        self.assertEqual(e2_tables.format_delivery(Decimal("99.4")), "99.4%")

    def test_p99_keeps_one_decimal(self) -> None:
        self.assertEqual(e2_tables.format_p99(Decimal("2.8")), "2.8")
        self.assertEqual(e2_tables.format_p99(Decimal("16.5")), "16.5")
        self.assertEqual(e2_tables.format_p99(Decimal("61.0")), "61.0")


class SheetTests(unittest.TestCase):
    def test_all_workload_tables_render(self) -> None:
        sheet = e2_tables.load_sheet(SHEET)
        self.assertEqual(
            e2_tables.markdown_table("scan", sheet["scan"]), SCAN_TABLE.rstrip("\n")
        )
        self.assertEqual(
            e2_tables.markdown_table("package", sheet["package"]),
            PACKAGE_TABLE.rstrip("\n"),
        )
        self.assertEqual(
            e2_tables.markdown_table("config", sheet["config"]),
            CONFIG_TABLE.rstrip("\n"),
        )

    def test_summary_replaces_similar_trends_wording(self) -> None:
        sheet = e2_tables.load_sheet(SHEET)
        text = e2_tables.summary_zh(sheet)
        self.assertIn("软件包下发", text)
        self.assertIn("配置下发", text)
        self.assertIn("1,065 hosts/s", text)
        self.assertIn("1,440 hosts/s", text)
        self.assertNotIn("类似趋势", text)
        doc = DOC.read_text()
        self.assertNotIn("shows similar trends", doc)
        self.assertIn("软件包下发", doc)
        self.assertIn("| KMOMP | 1065 |", doc)

    def test_require_all_succeeds(self) -> None:
        script = Path(__file__).resolve().parent / "e2_tables.py"
        completed = subprocess.run(
            [sys.executable, str(script), "--require-all"],
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(completed.returncode, 0, completed.stderr)
        self.assertIn("Table 14", completed.stdout)
        self.assertIn("Table 15", completed.stdout)

    def test_partial_row_is_rejected(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "measurements.csv"
            path.write_text(
                "workload,platform,throughput_hosts_per_s,p99_s,delivery_percent,"
                "max_concurrency,payload_bytes,configured_fanout,repeats,notes\n"
                "package,KMOMP,100,,,,,,\n"
                "package,Satellite 6.14,,,,,,\n"
                "package,Ansible AWX,,,,,,\n"
                "package,SUSE Manager,,,,,,\n"
                "scan,KMOMP,,,,,,\n"
                "scan,Satellite 6.14,,,,,,\n"
                "scan,Ansible AWX,,,,,,\n"
                "scan,SUSE Manager,,,,,,\n"
                "config,KMOMP,,,,,,\n"
                "config,Satellite 6.14,,,,,,\n"
                "config,Ansible AWX,,,,,,\n"
                "config,SUSE Manager,,,,,,\n"
            )
            with self.assertRaises(e2_tables.SheetError):
                e2_tables.load_sheet(path)


def _docx_tables(path: Path) -> list[list[list[str]]]:
    with zipfile.ZipFile(path) as archive:
        root = ET.fromstring(archive.read("word/document.xml"))
    tables = []
    for tbl in root.iter(W_TBL):
        rows = []
        for tr in tbl.findall(W_TR):
            cells = []
            for tc in tr:
                if not tc.tag.endswith("}tc"):
                    continue
                cells.append("".join(node.text or "" for node in tc.iter(W_T)))
            rows.append(cells)
        tables.append(rows)
    return tables


class DocxTests(unittest.TestCase):
    def test_word_document_has_filled_dispatch_tables(self) -> None:
        self.assertTrue(DOCX.is_file(), "run python3 eval/e2/write_docx.py")
        tables = _docx_tables(DOCX)
        self.assertEqual(len(tables), 4)
        _, scan, package, config = tables
        self.assertEqual(scan[1], ["KMOMP", "1847", "2.8", "99.99%", "high"])
        self.assertEqual(package[1], ["KMOMP", "1065", "3.8", "99.98%", "high"])
        self.assertEqual(config[1], ["KMOMP", "1440", "3.5", "99.99%", "high"])
        self.assertEqual(package[3], ["Ansible AWX", "51", "61.0", "99.4%", "low"])
        self.assertEqual(config[3], ["Ansible AWX", "70", "56.0", "99.5%", "low"])


if __name__ == "__main__":
    unittest.main()