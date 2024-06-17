return {
  { 'gracepetryk/rose-pine', priority = 2000, dev=true, config = function() require 'plugins.colors' end, lazy=false},

  { 'tpope/vim-sleuth' },

  {
    'tpope/vim-fugitive', -- git integration
    dependencies = {
      { 'tpope/vim-rhubarb' }, -- github integration
    },
    cmd = {'G', 'Gbrowse'}
  },

  { 'lewis6991/gitsigns.nvim', config = function() require 'plugins.gitsigns' end, event = 'VeryLazy' },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
    -- use opts = {} for passing setup options
    -- this is equalent to setup({}) function
  },

  {
    'nvim-telescope/telescope.nvim', branch = '0.1.x', config = function() require 'plugins.telescope' end,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
    },
    keys = {
      '<leader>ff',
      '<leader>FF',
      '<leader>fg',
      '<leader>fb',
      '<leader>fh',
      '<leader>fr'
    },
  },

  { 'Shatur/neovim-session-manager', config = function() require 'plugins.sessions' end, event = 'VeryLazy'},


  { 'williamboman/mason.nvim', lazy=true, cmd='Mason' }, -- install LSPs/DAP/etc
  { 'creativenull/efmls-configs-nvim', lazy=true },
  {
    'neovim/nvim-lspconfig',
    config= function() require 'plugins.lsp' end,
    event = 'VeryLazy',
  },


  {
    'hrsh7th/nvim-cmp',
    config = function() require 'plugins.completions' end,
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'L3MON4D3/LuaSnip', build = 'make install_jsregexp' },
      { 'saadparwaiz1/cmp_luasnip' },
    },
    event = 'VeryLazy'
  },

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
        config = function() require 'plugins.dapui' end,
        dependencies = {
          'nvim-neotest/nvim-nio'
        }
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

  { 'rodjek/vim-puppet', ft = {'pp', 'erb'} },
  { 'lepture/vim-jinja', ft = {'html'}},
}
