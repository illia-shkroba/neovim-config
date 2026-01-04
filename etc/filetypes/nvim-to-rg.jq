group_by(.filetype)
  | map({key: (.[0] | .filetype), value: (map(.rg_type) | unique)})
  | from_entries
