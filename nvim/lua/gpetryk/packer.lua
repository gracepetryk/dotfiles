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
  }

  --themes
  use { 'Mofiqul/vscode.nvim', opt = false }
  -- use{'EdenEast/nightfox.nvim', opt=false}

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function() require 'plugins.statusline' end,
    event = 'VimEnter'
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
    event = 'VimEnter'
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
    event = 'BufWinEnter',
  }

  use {
    'mfussenegger/nvim-dap',
    keys = {
      '<leader><leader>d',
      '<C-b>'
    },
    config = function() require 'plugins.dap' end
  }
  use {
    'rcarriga/nvim-dap-ui',
    requires = { 'mfussenegger/nvim-dap' },
    after = { 'nvim-dap' }
  }

  use {
    'rcarriga/cmp-dap',
    after = { 'nvim-dap', 'nvim-cmp' }
  }

  -- snippets
  use { 'hrsh7th/vim-vsnip' }
  use { 'hrsh7th/vim-vsnip-integ' }
  use { 'hrsh7th/cmp-vsnip', after = 'nvim-cmp' }

  use {
    'nvim-treesitter/nvim-treesitter',
    config = function() require 'plugins.treesitter' end,
    event = 'VimEnter'
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
      threshold = 1 -- the amount in ms that a plugin's load time must be over for it to be included in the profile
    }
  } })
