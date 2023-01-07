autocmd BufWritePost *config.h silent !sudo make install
" autocmd BufWritePost *help.md silent !pandoc -t beamer % -o %.pdf
autocmd BufWritePost *.Xresources silent !xrdb %

autocmd BufEnter *.cs call SetDotnetOptions()
autocmd BufEnter *.hs call SetHaskellOptions()
autocmd BufEnter *.java call SetJavaOptions()
autocmd BufEnter *.json call SetJSONOptions()
autocmd BufEnter *.md,*.tex,*.txt call SetTextOptions()
autocmd BufEnter *.py call SetPythonOptions()
autocmd BufEnter *.sh call SetShellScriptOptions()
autocmd BufEnter *.sql call SetSQLOptions()
autocmd BufEnter *Dockerfile call SetDockerfileOptions()
autocmd BufEnter *nginx.conf call SetNginxOptions()
autocmd BufEnter *.yaml,*.yml call SetYAMLOptions()
autocmd BufEnter site.yaml call SetAnsibleOptions()
autocmd BufEnter *.tf call SetTerraformOptions()
autocmd BufEnter *.vim call SetVimOptions()

autocmd BufNewFile *.scala 0r $XDG_CONFIG_HOME/nvim/template/template.scala | normal Gdd
autocmd BufNewFile *.java 0r $XDG_CONFIG_HOME/nvim/template/template.java | normal Gdd
autocmd BufNewFile *.cpp 0r $XDG_CONFIG_HOME/nvim/template/template.cpp | normal Gdd
autocmd BufNewFile *.md 0r $XDG_CONFIG_HOME/nvim/template/template.md | normal Gdd
autocmd BufNewFile *.hs 0r $XDG_CONFIG_HOME/nvim/template/template.hs | normal Gdd
