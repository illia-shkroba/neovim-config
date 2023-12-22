vim.g.mapleader = " "

require "package-manager"

local options = require "options"
options.set_default_options()
options.set_default_bindings()
options.set_default_autocommands()
options.enable_templates()
