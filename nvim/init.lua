require "plugins"
require "configs.lspconfig"

-- Configure Colors
vim.o.background = "dark"
vim.cmd.colorscheme "dracula"

-- Configure Settings
vim.cmd.filetype "off"
vim.cmd.filetype "plugin indent on"
vim.o.compatible = false
vim.o.ttyfast = true
vim.o.laststats = 1
vim.o.encoding = "utf-8"
vim.o.autoread = true
vim.o.autoindent = true
vim.o.backspace = "indent,eol,start"
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.hidden = true
vim.o.visualbell = true
vim.o.number = true
vim.o.backup = false
vim.o.swapfile = false
vim.o.showmode = false
vim.o.title = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true
vim.o.list = true
vim.opt.listchars:append { trail = "·", tab = "» " }
vim.o.spelllang = "en_us"
vim.o.completeopt = "noinsert,menuone,noselect"

vim.opt.clipboard:append { "unnamedplus" }
if vim.env.SPIN == "1" then
  vim.g.clipboard = {
    name = "pbcopy",
    copy = {
      ["+"] = "pbcopy",
      ["*"] = "pbcopy",
    },
    paste = {
      ["+"] = "pbpaste",
      ["*"] = "pbpaste",
    },
    cache_enabled = 1,
  }
end

vim.g.mapleader = ","

-- Default to magic mode when using substitution
vim.keymap.set("c", "%s/", "%s/\\v", { noremap = true })
vim.keymap.set("c", "\\>s/", "\\>s/\\v", { noremap = true })

-- Terminal Mode Mappings
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

-- Helper Functions and Mappings {{{
-- Easily manage quick fix windows
vim.keymap.set("n", "<C-n>", ":cnext<cr>", { silent = true })
vim.keymap.set("n", "<C-m>", ":cprevious<cr>", { silent = true })
vim.keymap.set("n", "<leader>q", ":cclose<cr>", { noremap = true, silent = true })

-- Buffer Navigation
vim.keymap.set("n", "<Tab>", ":bn<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<S-Tab>", ":bp<cr>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>x", ":bp | bd #<cr>", { noremap = true, silent = true })

-- Improve experience with ErgoDox
vim.keymap.set("i", "<C-\\>", "<Esc>", { noremap = true })
vim.keymap.set("n", "<C-\\>", "<Nop>", { noremap = true })

-- Capture current file path into clipboard
vim.keymap.set("n", "<leader>f", function() vim.fn.setreg("+", vim.fn.expand "%") end, { expr = true })

-- Rename current file
vim.keymap.set("n", "<leader>n", function()
  local old_name = vim.fn.expand "%"

  vim.ui.input({ prompt = "New file name: ", default = old_name }, function(new_name)
    if new_name ~= "" and new_name ~= old_name then
      vim.fn.execute(":saveas " .. new_name)
      vim.fn.execute(":silent !rm " .. old_name)
    end
  end)
end, { expr = true })

-- Fix indentation
vim.keymap.set("n", "<leader>i", "mmgg-G`m<CR>")

-- Toggle highlighting of search results
vim.keymap.set("n", "<leader><space>", ":nohlsearch<cr>", { noremap = true })

-- Unsmart Quotes
vim.keymap.set("n", "gudq", ':%s/\\v[“”]/"/g<cr>')
vim.keymap.set("n", "gusq", ":%s/\\v[‘’]/'/g<cr>")

-- vim-test configs
vim.g["test#strategy"] = "neovim"

vim.keymap.set("n", "<leader>t", ":TestFile<CR>", { silent = true })
vim.keymap.set("n", "<leader>T", ":TestNearest<CR>", { silent = true })
vim.keymap.set("n", "<leader>a", ":TestSuite<CR>", { silent = true })
vim.keymap.set("n", "<leader>l", ":TestLast<CR>", { silent = true })
vim.keymap.set("n", "<leader>g", ":TestVisit<CR>", { silent = true })

-- Format on Save
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]

-- Debugger insert
vim.cmd [[autocmd FileType ruby nnoremap <leader>bp orequire "debug"; binding.break<esc>]]
