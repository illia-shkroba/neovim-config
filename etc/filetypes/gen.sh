#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(dirname "$(readlink -e "$0")")"

types-cross() {
  rg --type-list \
    | while read -r line; do
      local rg_type
      rg_type=$(cut -d ':' -f 1 <<< "$line")

      echo "$line" | cut -d ':' -f 2 | tr -d ' ' | tr ',' '\n' \
        | while read -r pattern; do
          local filetype
          filetype=$(echo 'setl ft?' | nvim -es -- "$pattern" | cut -d '=' -f 2)

          echo '{"rg_type": "'"$rg_type"'", "pattern": "'"$pattern"'", "filetype": "'"$filetype"'"}'
        done
    done
}

types_cross_output=$(types-cross)

jq --slurp --from-file "$SCRIPT_DIR"/nvim-to-rg.jq > "$SCRIPT_DIR"/nvim-to-rg.json <<< "$types_cross_output"
jq --slurp --from-file "$SCRIPT_DIR"/rg-to-patterns.jq > "$SCRIPT_DIR"/rg-to-patterns.json <<< "$types_cross_output"
