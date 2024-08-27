-- Default to magic mode when using substitution
vim.keymap.set("c", "%s/", "%s/\\v", { noremap = true })
vim.keymap.set("c", "\\>s/", "\\>s/\\v", { noremap = true })

-- Terminal Mode Mappings
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true })

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
vim.keymap.set("n", "gudq", ':%s/\\v[""]/"/g<cr>')
vim.keymap.set("n", "gusq", ":%s/\\v['']/'/g<cr>")

-- vim-test configs
vim.g["test#strategy"] = "neovim"

vim.keymap.set("n", "<leader>t", ":TestFile<CR>", { silent = true })
vim.keymap.set("n", "<leader>T", ":TestNearest<CR>", { silent = true })
vim.keymap.set("n", "<leader>a", ":TestSuite<CR>", { silent = true })
vim.keymap.set("n", "<leader>l", ":TestLast<CR>", { silent = true })
vim.keymap.set("n", "<leader>g", ":TestVisit<CR>", { silent = true })