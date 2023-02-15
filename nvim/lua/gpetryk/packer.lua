vim.cmd [[packadd packer.nvim]]

return require('packer').startup({ function(use)
  -- Packer can manage itself
  use { 'wbthomason/packer.nvim', opt = false }

  use { 'tpope/vim-sleuth' } -- detect indentation

  use { 'tpope/vim-fugitive' } -- git integration
  use { 'tpope/vim-rhubarb' } -- github integration
  use {
    'lewis6991/gitsigns.nvim',
    config = function() require 'plugins.gitsigns' end,
    event = "CursorMoved"
  }

  --themes
  use { 'Mofiqul/vscode.nvim', opt = false }
  -- use{'EdenEast/nightfox.nvim', opt=false}

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function() require 'plugins.statusline' end,
  }

  use {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function() require 'plugins.telescope' end,
    keys = {
      '<leader>ff',
      '<leader>FF',
      '<leader>fg',
      '<leader>fb',
      '<leader>fh',
      '<leader>fr'
    }
  }

  use {
    'neovim/nvim-lspconfig',
    config = function() require 'plugins.lsp' end,
  } -- Configurations for Nvim LSP

  use {
    'hrsh7th/nvim-cmp',
    config = function() require 'plugins.completions' end,
    event = 'InsertEnter'
  }
  use { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' }
  use { 'hrsh7th/cmp-nvim-lsp-signature-help', after = 'nvim-cmp' }
  use {
    'jose-elias-alvarez/null-ls.nvim', -- allow non-lsp providers to hook into neovims lsp client (like flake8)
    config = function() require 'plugins.null-ls' end,
  }

  use {
    'mfussenegger/nvim-dap',
    config = function() require 'plugins.dap' end,
    keys = {
      '<C-b>',
      '<leader><leader>d'
    }
  }
  use {
    'rcarriga/nvim-dap-ui',
    requires = { 'mfussenegger/nvim-dap' },
    after = { 'nvim-dap' },
    config = function() require 'plugins.dapui' end
  }

  use {
    'rcarriga/cmp-dap',
    after = { 'nvim-cmp', 'nvim-dap', 'nvim-dap-ui' }
  }

  -- snippets
  use { 'hrsh7th/vim-vsnip' }
  use { 'hrsh7th/vim-vsnip-integ' }
  use { 'hrsh7th/cmp-vsnip', after = 'nvim-cmp' }

  use {
    'nvim-treesitter/nvim-treesitter',
    config = function() require 'plugins.treesitter' end,
  }
  use {
    'nvim-treesitter/nvim-treesitter-context',
    config = function() require 'plugins.context' end,
    after = 'nvim-treesitter'
  }
  use { 'nvim-treesitter/playground', after = 'nvim-treesitter' }

  -- language-specific plugins
  use { 'Vimjas/vim-python-pep8-indent' }
  use { 'mitsuhiko/vim-jinja' }
  use { 'iloginow/vim-stylus' }

  use { 'ThePrimeagen/harpoon' }

  use { 'dstein64/vim-startuptime' }

  use {
    'Shatur/neovim-session-manager',
    config = function() require 'plugins.sessions' end
  }
end,
  config = {
    profile = {
      enable = true,
    }
  } })
