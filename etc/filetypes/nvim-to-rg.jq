group_by(.filetype)
  | map({key: (.[0] | .filetype), value: map(del(.filetype))})
  | map(.value |= (
      group_by(.rg_type)
        | map({rg_type: (.[0] | .rg_type), filenames: map(.filename)})
    )
  )
  | from_entries
