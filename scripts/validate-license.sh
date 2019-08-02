#!/usr/bin/env bash
set -euxo pipefail
IFS=$'\n\t'

LICENSE_HEADER=""
LICENSE_COPYRIGHT_HEADER=""

find_files() {
  find . -not \( \
    \( -wholename './vendor' -o -wholename '*testdata*' \) -prune \
  \) \
  \( -name '*.go' -o -name '*.sh' \)
}

check_licensing() {
    local header_check=${1}
    local header_name=${2}
    failed_files=($(find_files | xargs grep -L "$header_check"))
    if (( ${#failed_files[@]} > 0 )); then
      echo "Some source files are missing the $header_name header(s)."
      for f in "${failed_files[@]}"; do
        echo "  $f"
      done
      exit 1
    fi
}

check_licensing ${LICENSE_HEADER} "license"
check_licensing ${LICENSE_COPYRIGHT_HEADER} "copyright"

