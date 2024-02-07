return {
  { 'tpope/vim-sleuth' },
  { 'tpope/vim-fugitive' }, -- git integration
  { 'tpope/vim-rhubarb' }, -- github integration
  {
    'lewis6991/gitsigns.nvim',
    config = function() require 'plugins.gitsigns' end,
    event = "VeryLazy"
  },

  -- show marks in sign column
  {
    'chentoast/marks.nvim',
    config = function() require('marks').setup({
      default_mappings = true,
      builtin_marks = { ">", "<" },
      sign_priority = 12
    }) end
  },

  --themes
  {
    'gracepetryk/rose-pine',
    priority = 2000,
    dev=true
  },

  { 'm4xshen/autoclose.nvim', config = function() require('autoclose').setup() end },
  { 'NvChad/nvim-colorizer.lua' },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function() require 'plugins.statusline' end,
    -- event = 'VeryLazy'
  },

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
  { 'williamboman/mason-lspconfig.nvim', },
  {
    'neovim/nvim-lspconfig',
    config= function() require 'plugins.lsp' end,
    event='VeryLazy'
  },
  { 'folke/neodev.nvim' },

  {
    'jose-elias-alvarez/null-ls.nvim', -- allow non-lsp providers to hook into neovims lsp client (like flake8)
    config = function() require 'plugins.null-ls' end,
    event = 'VeryLazy'
  },

  {
    'hrsh7th/nvim-cmp',
    config = function() require 'plugins.completions' end,
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'f3fora/cmp-spell' },
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
    build = ':TSUpdate'
  },

  { 'rodjek/vim-puppet' },
  { 'lepture/vim-jinja' },
  { 'clauseggers/vim-fontsyntax' }
}
