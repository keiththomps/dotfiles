-- Configure Colors
vim.o.background = "dark"
vim.cmd.colorscheme "dracula"

-- Configure Settings
vim.cmd.filetype "off"
vim.cmd.filetype "plugin indent on"
vim.o.compatible = false
vim.o.ttyfast = true
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
