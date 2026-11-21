#!/usr/bin/env python3
"""Checks for the E2 scan table and the unmeasured dispatch workloads."""

from __future__ import annotations

import subprocess
import sys
import tempfile
import unittest
from decimal import Decimal
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(Path(__file__).resolve().parent))

import e2_tables  # noqa: E402

DOC = ROOT / "docs" / "evaluation" / "e2-concurrent-throughput.md"
SHEET = Path(__file__).resolve().parent / "measurements.csv"

SCAN_TABLE = """\
Table 13. Concurrent scan throughput (1,000 hosts).

| Platform | Throughput (hosts/s) | P99 (s) | Delivery | Max concurrency |
| --- | ---: | ---: | ---: | --- |
| KMOMP | 1847 | 2.8 | 99.99% | high |
| Satellite 6.14 | 312 | 12.0 | 99.8% | mid |
| Ansible AWX | 89 | 45.0 | 99.5% | low |
| SUSE Manager | 276 | 14.5 | 99.7% | mid |
"""


class FormatTests(unittest.TestCase):
    def test_delivery_matches_table_13_style(self) -> None:
        self.assertEqual(e2_tables.format_delivery(Decimal("99.99")), "99.99%")
        self.assertEqual(e2_tables.format_delivery(Decimal("99.8")), "99.8%")
        self.assertEqual(e2_tables.format_delivery(Decimal("99.50")), "99.5%")
        self.assertEqual(e2_tables.format_delivery(Decimal("99.7")), "99.7%")

    def test_p99_keeps_one_decimal(self) -> None:
        self.assertEqual(e2_tables.format_p99(Decimal("2.8")), "2.8")
        self.assertEqual(e2_tables.format_p99(Decimal("12")), "12.0")
        self.assertEqual(e2_tables.format_p99(Decimal("45.0")), "45.0")
        self.assertEqual(e2_tables.format_p99(Decimal("14.5")), "14.5")


class SheetTests(unittest.TestCase):
    def test_scan_table_matches_supplied_results(self) -> None:
        sheet = e2_tables.load_sheet(SHEET)
        rendered = e2_tables.markdown_table("scan", sheet["scan"])
        self.assertEqual(rendered, SCAN_TABLE.rstrip("\n"))
        prose = e2_tables.prose("scan", sheet["scan"])
        self.assertIn("1,847 hosts/s", prose)
        self.assertIn("P99 of 2.8 s", prose)
        self.assertIn("99.99% delivery", prose)
        self.assertIn("312 hosts/s", prose)
        self.assertIn("P99 12.0 s", prose)
        self.assertIn("89 hosts/s", prose)
        self.assertIn("P99 45.0 s", prose)

    def test_package_and_config_are_withheld(self) -> None:
        sheet = e2_tables.load_sheet(SHEET)
        self.assertIsNone(e2_tables.markdown_table("package", sheet["package"]))
        self.assertIsNone(e2_tables.markdown_table("config", sheet["config"]))
        self.assertIsNone(e2_tables.latex_table("package", sheet["package"]))
        rendered = e2_tables.render_markdown(sheet)
        self.assertIn("Table 14 is withheld", rendered)
        self.assertIn("Table 15 is withheld", rendered)
        self.assertNotIn("| KMOMP | 1847 |", rendered.split("Table 14", 1)[1])

    def test_document_embeds_scan_and_withholds_dispatch_numbers(self) -> None:
        text = DOC.read_text()
        self.assertIn(SCAN_TABLE.strip(), text)
        self.assertIn("Table 14", text)
        self.assertIn("Table 15", text)
        self.assertNotIn("shows similar trends", text)
        package = text.split("## Package dispatch", 1)[1].split("## Configuration", 1)[0]
        config = text.split("## Configuration dispatch", 1)[1]
        for section in (package, config):
            self.assertNotIn("| KMOMP |", section)
            self.assertNotIn("1847", section)
            self.assertNotIn("99.99%", section)

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

    def test_require_all_exits_until_dispatch_is_measured(self) -> None:
        script = Path(__file__).resolve().parent / "e2_tables.py"
        completed = subprocess.run(
            [sys.executable, str(script), "--require-all"],
            check=False,
            capture_output=True,
            text=True,
        )
        self.assertEqual(completed.returncode, 2)
        self.assertIn("package", completed.stderr)
        self.assertIn("config", completed.stderr)


if __name__ == "__main__":
    unittest.main()
