runtime src/functions.vim
runtime! src/options/**/*.vim

filetype on

autocmd BufWritePost .Xresources,xresources silent !xrdb %
autocmd BufWritePost config.h silent !sudo make install
autocmd BufWritePost plugins.lua source % | PackerCompile

autocmd BufEnter *.hs call LSPCallback()
autocmd BufEnter *.lua call LSPCallback()
autocmd BufEnter *.nix call LSPCallback()
autocmd BufEnter *.purs call LSPCallback()
autocmd BufEnter *.py call LSPCallback()
autocmd BufEnter *.tf call LSPCallback()
autocmd BufEnter *.vim call LSPCallback()
autocmd BufEnter *Dockerfile call LSPCallback()
autocmd BufEnter site.yaml call LSPCallback()

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
