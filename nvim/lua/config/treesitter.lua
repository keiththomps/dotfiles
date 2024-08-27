require("nvim-treesitter.configs").setup {
  ensure_installed = { "lua", "vim", "ruby", "html", "elixir", "eex", "heex", "javascript", "css" },
  sync_install = false,
  ignore_install = {},
  highlight = {
    enable = true,
    disable = {},
  },
}
