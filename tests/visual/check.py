#!/usr/bin/env python3
"""Check one LaTeX/Typst PDF pair against the committed visual baseline."""

import argparse
import json
import subprocess
import tempfile
from itertools import zip_longest
from pathlib import Path

from PIL import Image, ImageChops, ImageFilter, ImageStat


def pdf_info(pdf: Path) -> dict[str, str]:
    result = subprocess.run(
        ["pdfinfo", pdf], check=True, text=True, capture_output=True
    )
    return dict(
        line.split(":", 1) for line in result.stdout.splitlines() if ":" in line
    )


def pages(pdf: Path, directory: Path, name: str) -> list[Path]:
    subprocess.run(
        ["pdftoppm", "-png", "-gray", "-r", "96", pdf, directory / name],
        check=True,
    )
    return sorted(
        directory.glob(f"{name}-*.png"),
        key=lambda p: int(p.stem.rsplit("-", 1)[1]),
    )


def pixel_data(image: Image.Image) -> list[int]:
    if hasattr(image, "get_flattened_data"):
        return list(image.get_flattened_data())
    return list(image.getdata())


def metrics(upper: Path, lower: Path, overlay: Path) -> dict[str, float]:
    a, b = Image.open(upper).convert("L"), Image.open(lower).convert("L")
    if a.size != b.size:
        raise AssertionError(f"raster sizes differ: {a.size} != {b.size}")
    mae = ImageStat.Stat(ImageChops.difference(a, b)).mean[0] / 255
    # Ink threshold and a 2px expansion make the geometric comparison robust
    # to antialiasing while retaining meaningful layout failures.
    ink_a = a.point(lambda value: 255 if value < 245 else 0).filter(
        ImageFilter.MaxFilter(5)
    )
    ink_b = b.point(lambda value: 255 if value < 245 else 0).filter(
        ImageFilter.MaxFilter(5)
    )
    pa, pb = pixel_data(ink_a), pixel_data(ink_b)
    union = sum(x or y for x, y in zip(pa, pb))
    iou = sum(x and y for x, y in zip(pa, pb)) / union if union else 1.0
    Image.merge("RGB", (a, b, ImageChops.darker(a, b))).save(overlay)
    return {"mae": mae, "iou": iou}


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("case")
    parser.add_argument("latex", type=Path)
    parser.add_argument("typst", type=Path)
    parser.add_argument(
        "--baseline", type=Path, default=Path("tests/visual/baseline.json")
    )
    parser.add_argument("--artifacts", type=Path, default=Path("build"))
    parser.add_argument("--write-baseline", action="store_true")
    parser.add_argument(
        "--report-only",
        action="store_true",
        help="write comparison artifacts without enforcing a baseline or threshold",
    )
    parser.add_argument("--max-mae", type=float)
    parser.add_argument("--min-iou", type=float)
    args = parser.parse_args()

    latex_info, typst_info = pdf_info(args.latex), pdf_info(args.typst)
    for info in (latex_info, typst_info):
        # Poppler rounds TeX and Typst dimensions differently; its explicit
        # paper-name classification is the stable A4 check.
        if not info.get("Page size", "").strip().endswith("(A4)"):
            raise AssertionError(f"not A4: {info.get('Page size')}")
    args.artifacts.mkdir(parents=True, exist_ok=True)
    latex_page_count = int(latex_info["Pages"])
    typst_page_count = int(typst_info["Pages"])
    (args.artifacts / f"{args.case}-pages.json").write_text(
        json.dumps(
            {
                "latex": latex_page_count,
                "typst": typst_page_count,
                "delta": typst_page_count - latex_page_count,
            },
            indent=2,
        )
        + "\n"
    )
    with tempfile.TemporaryDirectory() as temp:
        temp = Path(temp)
        latex_pages, typst_pages = (
            pages(args.latex, temp, "latex"),
            pages(args.typst, temp, "typst"),
        )
        observed = [
            metrics(a, b, args.artifacts / f"{args.case}-{number}.png")
            for number, (a, b) in enumerate(
                zip_longest(latex_pages, typst_pages), 1
            )
            if a is not None and b is not None
        ]
    baseline = (
        json.loads(args.baseline.read_text()) if args.baseline.exists() else {}
    )
    if args.write_baseline:
        baseline[args.case] = observed
        args.baseline.write_text(json.dumps(baseline, indent=2) + "\n")
        return
    (args.artifacts / f"{args.case}.json").write_text(
        json.dumps(observed, indent=2) + "\n"
    )
    if args.report_only:
        return
    if args.max_mae is not None or args.min_iou is not None:
        if args.max_mae is not None:
            for page, current in enumerate(observed, 1):
                if current["mae"] > args.max_mae:
                    raise AssertionError(
                        f"page {page}: MAE {current['mae']:.5f} exceeds "
                        f"{args.max_mae:.5f}"
                    )
        if args.min_iou is not None:
            for page, current in enumerate(observed, 1):
                if current["iou"] < args.min_iou:
                    raise AssertionError(
                        f"page {page}: IoU {current['iou']:.5f} below "
                        f"{args.min_iou:.5f}"
                    )
        return
    expected = baseline[args.case]
    if len(expected) != len(observed):
        raise AssertionError("baseline page count differs")
    for page, (current, reference) in enumerate(zip(observed, expected), 1):
        if current["mae"] > reference["mae"] + 0.001:
            raise AssertionError(
                f"page {page}: MAE {current['mae']:.5f} exceeds baseline"
            )
        if current["iou"] < max(0.63, reference["iou"] - 0.03):
            raise AssertionError(
                f"page {page}: IoU {current['iou']:.5f} below baseline"
            )


if __name__ == "__main__":
    main()
