return {
  -- Baseline Configuration
  "tpope/vim-fugitive",
  "tpope/vim-commentary",
  "vim-test/vim-test",

  -- LSP, Telescope, Treesitter
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",  -- load before opening files
    dependencies = {
      "williamboman/mason.nvim",
      -- Optional mason extensions:
      "williamboman/mason-lspconfig.nvim",  -- bridges Mason with lspconfig
      "nvimtools/none-ls.nvim",   -- bridges Mason with null-ls
    },
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

  -- Linting
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim", "williamboman/mason.nvim", "jay-babu/mason-null-ls.nvim" },
    config = function()
      require("config.linting")
    end,
  },

  -- Snippets & Autocomplete
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "onsails/lspkind.nvim",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
      "saadparwaiz1/cmp_luasnip",
    },
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
