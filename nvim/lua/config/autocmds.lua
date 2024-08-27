-- Format on Save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- Debugger insert
vim.cmd [[autocmd FileType ruby nnoremap <leader>bp orequire "pry"; binding.pry<esc>]]