-- Configure Telescope Keymaps
vim.keymap.set("n", "<leader>lf", "<cmd>Telescope find_files<cr>", { noremap = true })
vim.keymap.set("n", "<c-p>", "<cmd>Telescope find_files<cr>", { noremap = true })
vim.keymap.set("n", "<leader>lg", "<cmd>Telescope live_grep<cr>", { noremap = true })
vim.keymap.set("n", ";", "<cmd>Telescope buffers<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>lh", "<cmd>Telescope help_tags<cr>", { noremap = true })

local actions = require "telescope.actions"

require("telescope").setup {
  defaults = {
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
}
