nmap <leader>s :%s/\s\+$//gc<CR>
nmap <leader>t vip:!column -ts ' '<CR>
vmap <leader>t :!column -ts ' '<CR>
map <leader>o :lua vim.lsp.buf.hover()<CR>
nmap <leader>q :call QuoteNormal()<CR>
vmap <leader>q :call QuoteVisual()<CR>
nmap <leader>l :call EnableLSP()<CR>
nmap <leader>L :call DisableLSP()<CR>
nmap <leader>d :call delete(@%)<CR>
