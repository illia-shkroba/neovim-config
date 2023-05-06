runtime src/functions.vim
runtime! src/options/**/*.vim

autocmd BufWritePost *.Xresources silent !xrdb %
autocmd BufWritePost *config.h silent !sudo make install
autocmd BufWritePost plugins.lua source % | PackerCompile

autocmd BufEnter *.cs call SetDotnetOptions()
autocmd BufEnter *.hs call SetHaskellOptions()
autocmd BufEnter *.java call SetJavaOptions()
autocmd BufEnter *.json call SetJSONOptions()
autocmd BufEnter *.lua call SetLuaOptions()
autocmd BufEnter *.md,*.tex,*.txt call SetTextOptions()
autocmd BufEnter *.nix call SetNixOptions()
autocmd BufEnter *.purs call SetPureScriptOptions()
autocmd BufEnter *.py call SetPythonOptions()
autocmd BufEnter *.sh call SetShellScriptOptions()
autocmd BufEnter *.sql call SetSQLOptions()
autocmd BufEnter *.tf call SetTerraformOptions()
autocmd BufEnter *.vim call SetVimOptions()
autocmd BufEnter *.yaml,*.yml call SetYAMLOptions()
autocmd BufEnter *Dockerfile call SetDockerfileOptions()
autocmd BufEnter *nginx.conf call SetNginxOptions()
autocmd BufEnter site.yaml call SetAnsibleOptions()
call SetDefaultOptions()

function s:AddTemplateByExtension(extension)
  let templates_dir = stdpath("config") .. "/etc/templates/"
  call s:AddTemplate("*." .. a:extension, templates_dir .. "template." .. a:extension)
endfunction

function s:AddTemplate(pattern, template_path)
  execute "autocmd BufNewFile " .. a:pattern .. " 0r " .. a:template_path .. " | normal Gdd"
endfunction

call s:AddTemplateByExtension("scala")
call s:AddTemplateByExtension("java")
call s:AddTemplateByExtension("cpp")
call s:AddTemplateByExtension("md")
call s:AddTemplateByExtension("hs")

delfunction s:AddTemplateByExtension
delfunction s:AddTemplate
