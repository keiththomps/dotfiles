require('plugins')
require('configs.lspconfig')

-- Configure Colors
vim.o.background = 'dark'
vim.cmd.colorscheme('dracula')

-- Configure Settings
vim.cmd.filetype('off')
vim.cmd.filetype('plugin indent on')
vim.o.nocompatible = true
vim.o.ttyfast = true
vim.o.laststats = 1
vim.o.encoding = 'utf-8'
vim.o.autoread = true
vim.o.autoindent = true
vim.o.backspace = 'indent,eol,start'
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.hidden = true
vim.o.visualbell = true
vim.o.number = true
vim.o.nobackup = true
vim.o.noswapfile = true
vim.o.noshowmode = true
vim.o.title = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.list = true
vim.opt.listchars:append({ trail = '·', tab = '» ' })
vim.o.spelllang = 'en_us'
vim.o.completeopt = 'noinsert,menuone,noselect'

vim.opt.clipboard:append({ 'unnamedplus' })
if(vim.env.SPIN == '1') then
  vim.g.clipboard = {
    name = 'pbcopy',
    copy = {
      ['+'] = 'pbcopy',
      ['*'] = 'pbcopy',
    },
    paste = {
      ['+'] = 'pbpaste',
      ['*'] = 'pbpaste',
    },
    cache_enabled = 1
  }
end

vim.g.mapleader = ','

-- Default to magic mode when using substitution
vim.keymap.set('c', "%s/", "%s/\\v", { noremap = true })
vim.keymap.set('c', "\\>s/", "\\>s/\\v", { noremap = true })

-- Terminal Mode Mappings
vim.cmd.tnoremap("<Esc> <C-\\><C-n>")

-- Helper Functions and Mappings {{{
-- Easily manage quick fix windows
vim.cmd.map("<silent> <C-n> :cnext<CR>")
vim.cmd.map("<silent> <C-m> :cprevious<CR>")
vim.cmd.nnoremap("<silent> <leader>q :cclose<CR>")

-- Buffer Navigation
vim.cmd.nnoremap("<silent> <Tab> :bn<CR>")
vim.cmd.nnoremap("<silent> <S-Tab> :bp<CR>")
vim.cmd.nnoremap("<silent> <leader>x :bp\\|bd #<CR>")

-- Improve experience with ErgoDox
vim.cmd.inoremap("<C-\\> <Esc>")
vim.cmd.nnoremap("<C-\\> <Nop>")

-- Capture current file path into clipboard
vim.keymap.set('n', '<leader>f', function()
  vim.fn.setreg('+', vim.fn.expand('%'))
end, { expr = true })

-- Rename current file
vim.keymap.set('n', '<leader>n', function()
  local old_name = vim.fn.expand('%')

  vim.ui.input(
    { prompt = 'New file name: ' }, 
    function(new_name)
      if (new_name ~= '' and new_name ~= old_name) then
        vim.fn.execute(':saveas ' .. new_name)
        vim.fn.execute(':silent !rm ' .. old_name)
      end
    end
  )
end, { expr = true })

-- Fix indentation
vim.keymap.set('n', '<leader>i', 'mmgg-G`m<CR>')

-- Toggle highlighting of search results
vim.keymap.set('n', '<leader><space>', ':nohlsearch<cr>', { noremap = true })

-- Unsmart Quotes
vim.cmd.nnoremap('gudq :%s/\\v[“”]/"/g<cr>')
vim.cmd.nnoremap("gusq :%s/\\v[‘’]/'/g<cr>")
