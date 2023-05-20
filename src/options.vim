runtime src/functions.vim
runtime! src/options/**/*.vim

filetype on

autocmd BufWritePost .Xresources,xresources silent !xrdb %
autocmd BufWritePost config.h silent !sudo make install
autocmd BufWritePost plugins.lua source % | PackerCompile

autocmd BufEnter *.hs lua require("lsp").lsp_callback()
autocmd BufEnter *.lua lua require("lsp").lsp_callback()
autocmd BufEnter *.nix lua require("lsp").lsp_callback()
autocmd BufEnter *.purs lua require("lsp").lsp_callback()
autocmd BufEnter *.py lua require("lsp").lsp_callback()
autocmd BufEnter *.tf lua require("lsp").lsp_callback()
autocmd BufEnter *.vim lua require("lsp").lsp_callback()
autocmd BufEnter *Dockerfile lua require("lsp").lsp_callback()
autocmd BufEnter site.yaml lua require("lsp").lsp_callback()

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
