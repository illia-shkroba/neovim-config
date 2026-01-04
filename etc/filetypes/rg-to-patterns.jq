group_by(.rg_type)
  | map({key: (.[0] | .rg_type), value: map(.pattern)})
  | from_entries
