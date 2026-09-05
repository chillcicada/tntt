#!/usr/bin/env bash
# Build one configuration against a pinned ThuThesis checkout.
set -euo pipefail

if [[ $# -ne 5 ]]; then
  echo "usage: $0 DEGREE LANGUAGE OUTPUT LATEX_REFERENCE ARTIFACT_ROOT" >&2
  exit 2
fi

degree=$1
language=$2
output=$3
reference_root=$(realpath "$4")
artifact_root=$(realpath -m "$5")
script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
workspace_root=$(cd -- "$script_dir/../.." && pwd)
case_name="$degree-$language-$output"
case_root="$artifact_root/$case_name"
work_root="$workspace_root/build/visual-work/$case_name"
latex_output="$work_root/latex"
typst_output="$work_root/typst"
log_dir="$case_root/logs"
mkdir -p "$latex_output" "$typst_output" "$log_dir"

case "$language" in
  chinese) lang=zh ;;
  english) lang=en ;;
  *) echo "unsupported language: $language" >&2; exit 2 ;;
esac
case "$output" in
  electronic) twoside=false ;;
  print) twoside=true ;;
  *) echo "unsupported output: $output" >&2; exit 2 ;;
esac

collect_logs() {
  find "$latex_output" -maxdepth 1 -type f \
    \( -name '*.log' -o -name '*.blg' -o -name '*.out' \) \
    -exec cp -f {} "$log_dir"/ \; 2>/dev/null || true
  if [[ -f "$reference_root/thuthesis.log" ]]; then
    cp -f "$reference_root/thuthesis.log" "$log_dir/thuthesis-ins.log"
  fi
}
trap collect_logs EXIT

build_latex() {
  local source=$1
  local job_name=$2
  local run_bibtex=$3
  local input
  input="\\PassOptionsToClass{degree=$degree,degree-type=academic,language=$language,thesis-type=thesis,style-override=none,fontset=fandol}{thuthesis}\\def\\CompareOutput{$output}\\input{$source}"
  (
    cd "$reference_root"
    xelatex -halt-on-error -interaction=batchmode -file-line-error \
      -output-directory="$latex_output" -jobname="$job_name" "$input"
  )
  if [[ "$run_bibtex" == true ]]; then
    (
      cd "$latex_output"
      BIBINPUTS="$reference_root:" BSTINPUTS="$reference_root:" bibtex "$job_name"
    )
  fi
  for _ in 1 2; do
    (
      cd "$reference_root"
      xelatex -halt-on-error -interaction=batchmode -file-line-error \
        -output-directory="$latex_output" -jobname="$job_name" "$input"
    )
  done
}

(
  cd "$reference_root"
  xelatex -halt-on-error -interaction=batchmode thuthesis.ins
)

if [[ "$language" == chinese ]]; then
  full_source="$workspace_root/tests/visual/main.tex"
else
  full_source="$workspace_root/tests/visual/main-en.tex"
fi
build_latex "$full_source" "$case_name-full" true
build_latex "$workspace_root/tests/visual/cases.tex" "$case_name-focused" false

typst compile --root "$workspace_root" --font-path "$workspace_root/fonts" \
  --input "lang=$lang" --input "degree=$degree" \
  --input degree-type=academic --input "twoside=$twoside" \
  "$workspace_root/contrib/latex-parity/main.typ" \
  "$typst_output/$case_name-full.pdf" 2>"$log_dir/typst-full.log"

typst compile --root "$workspace_root" --font-path "$workspace_root/fonts" \
  --input "lang=$lang" --input "degree=$degree" \
  --input degree-type=academic --input "twoside=$twoside" \
  "$workspace_root/tests/visual/cases.typ" \
  "$typst_output/$case_name-focused.pdf" 2>"$log_dir/typst-focused.log"

reference_revision=$(git -C "$reference_root" rev-parse HEAD 2>/dev/null || printf unknown)
tntt_revision=$(git -C "$workspace_root" rev-parse HEAD 2>/dev/null || printf unknown)
typst_version=$(typst --version)
xelatex_version=$(xelatex --version | sed -n '1p')
metadata=(
  --meta "case=$case_name"
  --meta "degree=$degree"
  --meta "language=$language"
  --meta "output=$output"
  --meta "thuthesis_revision=$reference_revision"
  --meta "tntt_revision=$tntt_revision"
  --meta "typst_version=$typst_version"
  --meta "xelatex_version=$xelatex_version"
)

python3 "$script_dir/check.py" \
  "$latex_output/$case_name-full.pdf" "$typst_output/$case_name-full.pdf" \
  "$case_root/full" "${metadata[@]}" --meta fixture=full
python3 "$script_dir/check.py" \
  "$latex_output/$case_name-focused.pdf" \
  "$typst_output/$case_name-focused.pdf" \
  "$case_root/focused" "${metadata[@]}" --meta fixture=focused
