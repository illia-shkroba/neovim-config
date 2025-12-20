#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(dirname "$(readlink -e "$0")")"

types-cross() {
  rg --type-list \
    | while read -r line; do
      local rg_type
      rg_type=$(cut -d ':' -f 1 <<< "$line")

      echo "$line" | cut -d ':' -f 2 | tr -d ' ' | tr ',' '\n' \
        | while read -r filename; do
          local filetype
          filetype=$(echo 'setl ft?' | nvim -es -- "$filename" | cut -d '=' -f 2)

          echo '{"rg_type": "'"$rg_type"'", "filename": "'"$filename"'", "filetype": "'"$filetype"'"}'
        done
    done
}

types-cross | jq --slurp --from-file "$SCRIPT_DIR"/nvim-to-rg.jq > "$SCRIPT_DIR"/nvim-to-rg.json
types-cross | jq '.rg_type' | jq --slurp --compact-output 'unique' > "$SCRIPT_DIR"/rg.json
