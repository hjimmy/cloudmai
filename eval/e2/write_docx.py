#!/usr/bin/env python3
"""Write the E2 section to a Word document.

Scan, package-dispatch, and configuration-dispatch numbers come from the
measurement sheet and share the same table columns.
"""

from __future__ import annotations

import sys
from pathlib import Path

from docx import Document
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_LINE_SPACING
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Cm, Pt

sys.path.insert(0, str(Path(__file__).resolve().parent))

import e2_tables  # noqa: E402

OUT = Path(__file__).resolve().parents[2] / "docs" / "evaluation" / "e2-concurrent-throughput.docx"

LATIN = "Times New Roman"
EAST = "宋体"
RESULT_HEADERS = (
    "Platform",
    "Throughput (hosts/s)",
    "P99 (s)",
    "Delivery",
    "Max concurrency",
)


def _rfonts(rPr, latin: str, east: str) -> None:
    rFonts = rPr.find(qn("w:rFonts"))
    if rFonts is None:
        rFonts = OxmlElement("w:rFonts")
        rPr.append(rFonts)
    rFonts.set(qn("w:ascii"), latin)
    rFonts.set(qn("w:hAnsi"), latin)
    rFonts.set(qn("w:cs"), latin)
    rFonts.set(qn("w:eastAsia"), east)


def set_style_font(style, size_pt: int, *, bold: bool = False) -> None:
    style.font.name = LATIN
    style.font.size = Pt(size_pt)
    style.font.bold = bold
    style.font.color.rgb = None
    rPr = style.element.get_or_add_rPr()
    _rfonts(rPr, LATIN, EAST)


def add_run(paragraph, text: str, *, bold: bool = False, size: int = 12):
    run = paragraph.add_run(text)
    run.bold = bold
    run.font.size = Pt(size)
    run.font.name = LATIN
    run._element.rPr.rFonts.set(qn("w:eastAsia"), EAST)
    return run


def add_body(doc: Document, text: str, *, center: bool = False, first_indent: bool = True):
    paragraph = doc.add_paragraph()
    paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER if center else WD_ALIGN_PARAGRAPH.JUSTIFY
    fmt = paragraph.paragraph_format
    fmt.line_spacing_rule = WD_LINE_SPACING.ONE_POINT_FIVE
    fmt.space_before = Pt(0)
    fmt.space_after = Pt(6)
    fmt.first_line_indent = Cm(0.74) if first_indent and not center else Cm(0)
    add_run(paragraph, text)
    return paragraph


def add_caption(doc: Document, text: str):
    paragraph = doc.add_paragraph()
    paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
    fmt = paragraph.paragraph_format
    fmt.space_before = Pt(12)
    fmt.space_after = Pt(4)
    fmt.line_spacing_rule = WD_LINE_SPACING.SINGLE
    add_run(paragraph, text, bold=True, size=11)
    return paragraph


def add_note(doc: Document, text: str):
    paragraph = doc.add_paragraph()
    paragraph.alignment = WD_ALIGN_PARAGRAPH.LEFT
    fmt = paragraph.paragraph_format
    fmt.space_before = Pt(2)
    fmt.space_after = Pt(10)
    fmt.line_spacing_rule = WD_LINE_SPACING.SINGLE
    add_run(paragraph, text, size=10)
    return paragraph


def _shade(cell, fill: str) -> None:
    tcPr = cell._tc.get_or_add_tcPr()
    shd = OxmlElement("w:shd")
    shd.set(qn("w:val"), "clear")
    shd.set(qn("w:color"), "auto")
    shd.set(qn("w:fill"), fill)
    tcPr.append(shd)


def _set_widths(table, widths_cm: list[float]) -> None:
    widths = [int(Cm(w).twips) for w in widths_cm]
    table.autofit = False
    table.allow_autofit = False
    tbl = table._tbl
    tblPr = tbl.tblPr
    tblW = tblPr.find(qn("w:tblW"))
    if tblW is None:
        tblW = OxmlElement("w:tblW")
        tblPr.append(tblW)
    tblW.set(qn("w:w"), str(sum(widths)))
    tblW.set(qn("w:type"), "dxa")
    grid = tbl.find(qn("w:tblGrid"))
    for node, width in zip(grid, widths):
        node.set(qn("w:w"), str(width))
    for row in table.rows:
        for cell, width in zip(row.cells, widths):
            tcPr = cell._tc.get_or_add_tcPr()
            tcW = tcPr.find(qn("w:tcW"))
            if tcW is None:
                tcW = OxmlElement("w:tcW")
                tcPr.append(tcW)
            tcW.set(qn("w:w"), str(width))
            tcW.set(qn("w:type"), "dxa")


def _write_cell(cell, text: str, *, bold: bool = False, fill: str | None = None) -> None:
    cell.text = ""
    paragraph = cell.paragraphs[0]
    paragraph.alignment = WD_ALIGN_PARAGRAPH.CENTER
    fmt = paragraph.paragraph_format
    fmt.space_before = Pt(2)
    fmt.space_after = Pt(2)
    fmt.line_spacing_rule = WD_LINE_SPACING.SINGLE
    add_run(paragraph, text, bold=bold, size=10)
    if fill:
        _shade(cell, fill)
    tcPr = cell._tc.get_or_add_tcPr()
    vAlign = OxmlElement("w:vAlign")
    vAlign.set(qn("w:val"), "center")
    tcPr.append(vAlign)


def add_table(doc: Document, headers: tuple[str, ...], rows: list[tuple[str, ...]], widths_cm: list[float]):
    table = doc.add_table(rows=1 + len(rows), cols=len(headers))
    table.style = "Table Grid"
    table.alignment = WD_ALIGN_PARAGRAPH.CENTER
    for index, header in enumerate(headers):
        _write_cell(table.rows[0].cells[index], header, bold=True, fill="D9E2F3")
    for r_index, row in enumerate(rows):
        fill = "F7F7F7" if r_index % 2 == 1 else None
        for c_index, value in enumerate(row):
            _write_cell(table.rows[r_index + 1].cells[c_index], value, fill=fill)
    _set_widths(table, widths_cm)
    return table


def result_rows(sheet, workload: str) -> list[tuple[str, str, str, str, str]]:
    rows = []
    ready = e2_tables.workload_ready(sheet[workload])
    for platform in e2_tables.PLATFORMS:
        measured = sheet[workload][platform] if ready else None
        if measured is None:
            rows.append((platform, "", "", "", ""))
        else:
            rows.append(
                (
                    platform,
                    measured["throughput"],
                    measured["p99"],
                    measured["delivery"],
                    measured["concurrency"],
                )
            )
    return rows


def build(sheet_path: Path | None = None) -> Document:
    sheet = e2_tables.load_sheet(sheet_path or e2_tables.SHEET)
    doc = Document()
    for style_name, size, bold in (
        ("Normal", 12, False),
        ("Heading 1", 16, True),
        ("Heading 2", 14, True),
    ):
        set_style_font(doc.styles[style_name], size, bold=bold)

    section = doc.sections[0]
    section.page_width = Cm(21.0)
    section.page_height = Cm(29.7)
    section.left_margin = Cm(2.5)
    section.right_margin = Cm(2.5)
    section.top_margin = Cm(2.5)
    section.bottom_margin = Cm(2.5)

    title = doc.add_heading("E2  并发吞吐（1,000 台主机）", level=1)
    title.alignment = WD_ALIGN_PARAGRAPH.CENTER
    subtitle = doc.add_paragraph()
    subtitle.alignment = WD_ALIGN_PARAGRAPH.CENTER
    subtitle.paragraph_format.space_after = Pt(12)
    add_run(
        subtitle,
        "Concurrent scan, package dispatch, and configuration dispatch",
        size=12,
    )

    add_body(doc, e2_tables.summary_zh(sheet))
    add_body(
        doc,
        "四平台为 KMOMP、Satellite 6.14、Ansible AWX 和 SUSE Manager。每组报告吞吐（hosts/s）、"
        "P99（秒）、送达率和最大并发等级（high、mid、low）。吞吐和 P99 分开测量，互不换算。",
        first_indent=False,
    )

    add_caption(doc, "三组实验")
    add_table(
        doc,
        ("组", "表", "每台主机上的动作", "计入送达的条件"),
        [
            ("并发扫描", "表 13", "采集一份扫描报告", "服务器接受完整报告"),
            ("软件包下发", "表 14", "安装一个软件包", "包数据库报出指定版本，且服务器接受回执"),
            ("配置下发", "表 15", "写入一个配置单元", "回读内容与目标一致，且服务器接受回执"),
        ],
        [3.2, 2.2, 4.8, 5.8],
    )

    doc.add_heading("共同方法", level=2)
    add_body(
        doc,
        "每一组都是一轮 1,000 台主机。开始前停掉后台同步和计划任务，使这一轮是唯一的下发。"
        "单台时延从服务器接纳该主机起，到上面的成功条件被记录为止。吞吐是持续完成速率，单位为主机/秒。"
        "P99 是单台时延的第 99 百分位。送达率是核验成功的主机数除以 1,000。"
        "已发表的扫描 P99 长于 1,000 除以扫描速率，说明主机是流水进入的，因此两列都按实测填写。",
    )
    add_body(
        doc,
        "动作走各平台自己的扫描、软件包和配置通道。软件包下发开始前，主机上没有该包；"
        "配置下发开始前，主机上的内容与目标不同，写入可以被回读核对。软件包字节数和配置单元字节数是表 14、表 15 的控制量。扫描没有载荷。",
    )

    doc.add_heading("并发扫描", level=2)
    add_body(doc, e2_tables.prose("scan", sheet["scan"]), first_indent=False)
    add_caption(doc, "表 13  Concurrent scan throughput (1,000 hosts)")
    add_table(doc, RESULT_HEADERS, result_rows(sheet, "scan"), [3.6, 3.6, 2.2, 2.6, 3.6])

    doc.add_heading("软件包下发", level=2)
    add_body(
        doc,
        "每一台主机安装同一个软件包；送达须在包数据库中见到指定版本且服务器接受回执。",
        first_indent=False,
    )
    add_body(doc, e2_tables.prose("package", sheet["package"]), first_indent=False)
    add_caption(doc, "表 14  Concurrent package-dispatch throughput (1,000 hosts)")
    add_table(doc, RESULT_HEADERS, result_rows(sheet, "package"), [3.6, 3.6, 2.2, 2.6, 3.6])

    doc.add_heading("配置下发", level=2)
    add_body(
        doc,
        "配置单元是一个文件或一个键，1,000 台主机使用同一份目标内容；送达须回读一致且服务器接受回执。",
        first_indent=False,
    )
    add_body(doc, e2_tables.prose("config", sheet["config"]), first_indent=False)
    add_caption(doc, "表 15  Concurrent configuration-dispatch throughput (1,000 hosts)")
    add_table(doc, RESULT_HEADERS, result_rows(sheet, "config"), [3.6, 3.6, 2.2, 2.6, 3.6])
    return doc


def main() -> int:
    document = build()
    OUT.parent.mkdir(parents=True, exist_ok=True)
    document.save(OUT)
    print(OUT)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
