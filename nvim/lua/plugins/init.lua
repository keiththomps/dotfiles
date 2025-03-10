return {
  -- Baseline Configuration
  "tpope/vim-fugitive",
  "tpope/vim-commentary",
  "vim-test/vim-test",

  -- LSP, Telescope, Treesitter, Avante
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "mfussenegger/nvim-lint",
    dependencies = { "rshkarin/mason-nvim-lint" },
    config = function()
      require("config.linting")
    end,
  },
  "neovim/nvim-lspconfig",
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("config.lsp")
    end,
  },
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      require("config.telescope")
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("config.treesitter")
    end,
  },

  -- Claude Code integration
  {
    "greggh/claude-code.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim", -- Required for git operations
    },
    config = function()
      require("config.claude")
    end
  },

  -- Snippets
  "L3MON4D3/LuaSnip",
  "rafamadriz/friendly-snippets",
  "saadparwaiz1/cmp_luasnip",

  -- Autocomplete
  "onsails/lspkind.nvim",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "hrsh7th/cmp-path",
  "hrsh7th/cmp-cmdline",
  {
    "hrsh7th/nvim-cmp",
    config = function()
      require("config.cmp")
    end,
  },

  -- Indent detection
  {
    "Darazaki/indent-o-matic",
    config = function()
      require("indent-o-matic").setup({})
    end,
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },

  -- Appearance
  { "Mofiqul/dracula.nvim", name = "dracula" },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
    config = function()
      require("lualine").setup({})
    end,
  },
}
