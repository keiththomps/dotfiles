local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Baseline Configuration
  use 'tpope/vim-commentary'
  use 'vim-test/vim-test'

  -- LSP, Telescope, Treesitter
  use {
    'williamboman/mason.nvim',
    run = ":MasonUpdate"
  }
  use 'jose-elias-alvarez/null-ls.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'jay-babu/mason-null-ls.nvim'
  use { 'neovim/nvim-lspconfig' }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {'nvim-lua/plenary.nvim' },
    config = function() require('configs.telescope') end
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }
  
  -- Snippets
  use 'L3MON4D3/LuaSnip'
  use 'rafamadriz/friendly-snippets'
  use 'saadparwaiz1/cmp_luasnip'

  -- Autocomplete
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-path' }
  use { 'hrsh7th/cmp-cmdline' }
  use { 'hrsh7th/nvim-cmp', config = function() require('configs.cmp') end }

  -- Indent detection
  use { 'Darazaki/indent-o-matic', config = function() require('indent-o-matic').setup {} end }
  use { 'windwp/nvim-autopairs', config = function() require('nvim-autopairs').setup {} end }

  -- Copilot
  use { 'github/copilot.vim', branche = 'release' }

  -- Appearance
  use { 'Mofiqul/dracula.nvim', as = 'dracula' }
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function() require('lualine').setup {} end
  }

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
