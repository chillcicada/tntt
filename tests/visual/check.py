#!/usr/bin/env python3
"""Render a color overlay showing the differences between two PDFs."""

import argparse
import subprocess
import tempfile
from itertools import zip_longest
from pathlib import Path

from PIL import Image, ImageChops

RESOLUTION = 144


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


def open_page(path: Path) -> Image.Image:
    with Image.open(path) as image:
        return image.convert("L")


def overlay_pdfs(upper_pdf: Path, lower_pdf: Path, output: Path) -> None:
    with tempfile.TemporaryDirectory() as temporary_directory:
        directory = Path(temporary_directory)
        upper_pages = rasterize(upper_pdf, directory, "upper")
        lower_pages = rasterize(lower_pdf, directory, "lower")
        overlays = []

        for number, (upper_path, lower_path) in enumerate(
            zip_longest(upper_pages, lower_pages), 1
        ):
            upper = open_page(upper_path) if upper_path else None
            lower = open_page(lower_path) if lower_path else None
            if (
                upper is not None
                and lower is not None
                and upper.size != lower.size
            ):
                raise SystemExit(
                    f"page {number} size differs: {upper.size} != {lower.size}"
                )
            reference = upper if upper is not None else lower
            assert reference is not None
            size = reference.size
            upper = upper if upper is not None else Image.new("L", size, 255)
            lower = lower if lower is not None else Image.new("L", size, 255)
            overlays.append(
                Image.merge(
                    "RGB", (upper, lower, ImageChops.darker(upper, lower))
                )
            )
            upper.close()
            lower.close()

        if not overlays:
            raise SystemExit("cannot compare PDFs without pages")
        output.parent.mkdir(parents=True, exist_ok=True)
        overlays[0].save(
            output,
            save_all=True,
            append_images=overlays[1:],
            resolution=RESOLUTION,
        )
        for overlay in overlays:
            overlay.close()


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "upper", type=Path, help="PDF shown in the green channel"
    )
    parser.add_argument("lower", type=Path, help="PDF shown in the red channel")
    parser.add_argument(
        "output", type=Path, nargs="?", default=Path("overlay.pdf")
    )
    args = parser.parse_args()
    overlay_pdfs(args.upper, args.lower, args.output)


if __name__ == "__main__":
    main()
