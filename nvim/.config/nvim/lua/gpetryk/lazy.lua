return {
  { 'tpope/vim-sleuth' },
  { 'tpope/vim-fugitive' }, -- git integration
  { 'tpope/vim-rhubarb' }, -- github integration
  {
    'lewis6991/gitsigns.nvim',
    config = function() require 'plugins.gitsigns' end,
    event = "VeryLazy"
  },

  --themes
  {
    'gracepetryk/rose-pine',
    priority = 2000,
    dev=true
  },

  { 'm4xshen/autoclose.nvim', config = function() require('autoclose').setup() end },

  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x',
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
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
    'Shatur/neovim-session-manager',
    config = function() require 'plugins.sessions' end,
    event = 'BufWritePost',
    cmd = 'SessionManager'
  },


  { 'williamboman/mason.nvim' }, -- install LSPs/DAP/etc
  {
    'neovim/nvim-lspconfig',
    config= function() require 'plugins.lsp' end,
    event='VeryLazy'
  },

  {
    'hrsh7th/nvim-cmp',
    config = function() require 'plugins.completions' end,
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
    },
  },

  { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
  { 'saadparwaiz1/cmp_luasnip' },

  {
    'mfussenegger/nvim-dap',
    config = function() require 'plugins.dap' end,
    keys = {
      '<C-b>',
      '<leader>d'
    },
    dependencies = {
      {
        'rcarriga/nvim-dap-ui',
        config = function() require 'plugins.dapui' end
      },
      { 'rcarriga/cmp-dap' },
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
    },
    build = ':TSUpdate',
    dev=true
  },

  { 'rodjek/vim-puppet' },
  { 'lepture/vim-jinja' },
}
