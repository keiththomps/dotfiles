local telescope = require("telescope")
local actions = require("telescope.actions")

telescope.setup({
  defaults = {
    file_ignore_patterns = { "%.jpg", "%.jpeg", "%.png", "%.gif", "%.bmp", "%.tiff", "%.svg" },
    mappings = {
      i = {
        ["<esc>"] = actions.close,
      },
    },
  },
})

telescope.load_extension("fzf")

-- Configure Telescope Keymaps
vim.keymap.set("n", "<leader>lf", "<cmd>Telescope find_files<cr>", { noremap = true })
vim.keymap.set("n", "<c-p>", "<cmd>Telescope find_files<cr>", { noremap = true })
vim.keymap.set("n", "<leader>lg", "<cmd>Telescope live_grep<cr>", { noremap = true })
vim.keymap.set("n", ";", "<cmd>Telescope buffers<cr>", { silent = true, noremap = true })
vim.keymap.set("n", "<leader>lh", "<cmd>Telescope help_tags<cr>", { noremap = true })

