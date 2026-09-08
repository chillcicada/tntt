#!/usr/bin/env python3
"""Create a self-contained, page-by-page PDF comparison bundle."""

import argparse
import json
import shutil
import subprocess
import tempfile
from itertools import zip_longest
from pathlib import Path

from PIL import Image, ImageChops, ImageDraw, ImageFont

RESOLUTION = 144
HEADER_HEIGHT = 48


def rasterize(pdf: Path, directory: Path, name: str) -> list[Path]:
    subprocess.run(
        [
            "pdftoppm",
            "-png",
            "-gray",
            "-r",
            str(RESOLUTION),
            pdf,
            directory / name,
        ],
        check=True,
    )
    return sorted(
        directory.glob(f"{name}-*.png"),
        key=lambda path: int(path.stem.rsplit("-", 1)[1]),
    )


def open_page(path: Path | None) -> Image.Image | None:
    if path is None:
        return None
    with Image.open(path) as image:
        return image.convert("L")


def fit_page(page: Image.Image | None, size: tuple[int, int]) -> Image.Image:
    canvas = Image.new("L", size, 255)
    if page is not None:
        canvas.paste(page, (0, 0))
    return canvas


def label_font() -> ImageFont.FreeTypeFont | ImageFont.ImageFont:
    try:
        return ImageFont.truetype("DejaVuSans.ttf", 20)
    except OSError:
        return ImageFont.load_default()


def save_pdf(pages: list[Path], output: Path) -> None:
    images = [Image.open(page) for page in pages]
    try:
        images[0].save(
            output,
            save_all=True,
            append_images=images[1:],
            resolution=RESOLUTION,
        )
    finally:
        for image in images:
            image.close()


def render_comparison(
    reference_pdf: Path,
    candidate_pdf: Path,
    output: Path,
    metadata: dict[str, str],
) -> None:
    output.mkdir(parents=True, exist_ok=True)
    shutil.copy2(reference_pdf, output / "latex.pdf")
    shutil.copy2(candidate_pdf, output / "typst.pdf")

    with tempfile.TemporaryDirectory() as temporary_directory:
        directory = Path(temporary_directory)
        reference_paths = rasterize(reference_pdf, directory, "reference")
        candidate_paths = rasterize(candidate_pdf, directory, "candidate")
        overlay_paths: list[Path] = []
        comparison_paths: list[Path] = []
        page_reports = []
        font = label_font()

        for number, (reference_path, candidate_path) in enumerate(
            zip_longest(reference_paths, candidate_paths), 1
        ):
            reference = open_page(reference_path)
            candidate = open_page(candidate_path)
            sizes = [page.size for page in (reference, candidate) if page]
            if not sizes:
                raise SystemExit("cannot compare PDFs without pages")
            size = (max(item[0] for item in sizes), max(item[1] for item in sizes))
            reference_page = fit_page(reference, size)
            candidate_page = fit_page(candidate, size)
            overlay = Image.merge(
                "RGB",
                (
                    reference_page,
                    candidate_page,
                    ImageChops.darker(reference_page, candidate_page),
                ),
            )

            comparison = Image.new(
                "RGB", (size[0] * 3, size[1] + HEADER_HEIGHT), "white"
            )
            comparison.paste(reference_page.convert("RGB"), (0, HEADER_HEIGHT))
            comparison.paste(candidate_page.convert("RGB"), (size[0], HEADER_HEIGHT))
            comparison.paste(overlay, (size[0] * 2, HEADER_HEIGHT))
            draw = ImageDraw.Draw(comparison)
            draw.text(
                (12, 12), f"Page {number}: LaTeX reference", fill="black", font=font
            )
            draw.text(
                (size[0] + 12, 12),
                f"Page {number}: Typst candidate",
                fill="black",
                font=font,
            )
            draw.text(
                (size[0] * 2 + 12, 12),
                "Overlay: green=LaTeX, red=Typst",
                fill="black",
                font=font,
            )

            overlay_path = directory / f"overlay-{number:04d}.png"
            comparison_path = directory / f"comparison-{number:04d}.png"
            overlay.save(overlay_path)
            comparison.save(comparison_path)
            overlay_paths.append(overlay_path)
            comparison_paths.append(comparison_path)
            page_reports.append(
                {
                    "page": number,
                    "latex_present": reference is not None,
                    "typst_present": candidate is not None,
                    "latex_size": list(reference.size) if reference else None,
                    "typst_size": list(candidate.size) if candidate else None,
                }
            )

            if reference is not None:
                reference.close()
            if candidate is not None:
                candidate.close()
            reference_page.close()
            candidate_page.close()
            overlay.close()
            comparison.close()

        if not overlay_paths:
            raise SystemExit("cannot compare PDFs without pages")
        save_pdf(overlay_paths, output / "overlay.pdf")
        save_pdf(comparison_paths, output / "comparison.pdf")

    report = {
        "metadata": metadata,
        "resolution_dpi": RESOLUTION,
        "latex_pages": len(reference_paths),
        "typst_pages": len(candidate_paths),
        "same_page_count": len(reference_paths) == len(candidate_paths),
        "same_page_sizes": all(
            page["latex_size"] == page["typst_size"] for page in page_reports
        ),
        "pages": page_reports,
    }
    (output / "report.json").write_text(
        json.dumps(report, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )

    fixture = metadata.get("fixture", "PDF")
    case = metadata.get("case", "layout comparison")
    readme = f"""# {case}: {fixture}

Open `comparison.pdf` first. Each page contains the LaTeX reference, the Typst
candidate, and their color overlay in three columns. In the overlay, green marks
content found only in LaTeX, red marks content found only in Typst, and black
marks matching content.

- `latex.pdf`: original reference output
- `typst.pdf`: original candidate output
- `comparison.pdf`: three-column review document
- `overlay.pdf`: full-size color overlay
- `report.json`: configuration, page counts, page presence, and page sizes

- LaTeX pages: {len(reference_paths)}
- Typst pages: {len(candidate_paths)}
"""
    (output / "README.md").write_text(readme, encoding="utf-8")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("reference", type=Path, help="LaTeX reference PDF")
    parser.add_argument("candidate", type=Path, help="Typst candidate PDF")
    parser.add_argument("output", type=Path, help="comparison bundle directory")
    parser.add_argument(
        "--meta",
        action="append",
        default=[],
        metavar="KEY=VALUE",
        help="metadata to record in report.json; may be repeated",
    )
    args = parser.parse_args()
    try:
        metadata = dict(item.split("=", 1) for item in args.meta)
    except ValueError:
        parser.error("every --meta value must have the form KEY=VALUE")
    render_comparison(args.reference, args.candidate, args.output, metadata)


if __name__ == "__main__":
    main()
