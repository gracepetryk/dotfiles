return {
  { 'tpope/vim-sleuth' }, -- detect indentation

  { 'tpope/vim-fugitive' }, -- git integration
  { 'tpope/vim-rhubarb' }, -- github integration
  {
    'lewis6991/gitsigns.nvim',
    config = function() require 'plugins.gitsigns' end,
    event = "VeryLazy"
  },

  --themes
  { 'Mofiqul/vscode.nvim', priority=100},

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function() require 'plugins.statusline' end,
    event='VeryLazy'
  },

  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = { { 'nvim-lua/plenary.nvim' }, },
    config = function() require 'plugins.telescope' end,
    keys = {
      '<leader>ff',
      '<leader>FF',
      '<leader>fg',
      '<leader>fb',
      '<leader>fh',
      '<leader>fr'
    },
  },

  {
    'neovim/nvim-lspconfig',
    config = function() require 'plugins.lsp' end,
  }, -- Configurations for Nvim LSP

  {
    'jose-elias-alvarez/null-ls.nvim', -- allow non-lsp providers to hook into neovims lsp client (like flake8)
    config = function() require 'plugins.null-ls' end,
    event='VeryLazy'
  },
  {
    'j-hui/fidget.nvim',
    config=true,
    event='VeryLazy'
  },

  {
    'hrsh7th/nvim-cmp',
    config = function() require 'plugins.completions' end,
    event = 'InsertEnter',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help' },
      {
        'hrsh7th/cmp-vsnip',
        dependencies = {
          { 'hrsh7th/vim-vsnip' },
          { 'hrsh7th/vim-vsnip-integ' },
        },
      }
    }
  },

  {
    'mfussenegger/nvim-dap',
    config = function() require 'plugins.dap' end,
    keys = {
      '<C-b>',
      '<leader><leader>d'
    },
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        config = function() require 'plugins.dapui' end
      },
      {
        'rcarriga/cmp-dap',
        dependencies = {'nvim-cmp'}
      },
    }
  },

  {
    'nvim-treesitter/nvim-treesitter',
    config = function() require 'plugins.treesitter' end,
    event = 'VeryLazy',
    dependencies = {
      {
        'nvim-treesitter/nvim-treesitter-context',
        config = function() require 'plugins.context' end,
      },
      { 'nvim-treesitter/playground' },
    }
  },

  -- language-specific plugins
  { 'Vimjas/vim-python-pep8-indent', ft='python' },
  { 'mitsuhiko/vim-jinja' },
  { 'iloginow/vim-stylus' },

  { 'ThePrimeagen/harpoon' },

  {
    'dstein64/vim-startuptime',
    cmd='StartupTime'
  },

  {
    'Shatur/neovim-session-manager',
    config = function() require 'plugins.sessions' end
  }
}
