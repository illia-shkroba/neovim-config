lua << EOF
  -- plugins should be loaded first
  require("plugins")

  local options = require "options"
  options.set_default_options()
  options.set_default_bindings { leader_key = " " }
EOF

runtime src/options.vim
