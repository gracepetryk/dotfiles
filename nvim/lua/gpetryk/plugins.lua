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
  {
    dir='~/dotfiles/grace-rose-pine',
    name = 'grace-rose-pine',
    priority = 2000,
    dev=true
  },

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function() require 'plugins.statusline' end,
    -- event = 'VeryLazy'
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
    event = 'InsertEnter',
    dependencies = {
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-buffer' },
      { 'rcarriga/cmp-dap' },
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
    }
  },

  {
    'RRethy/vim-illuminate',
    event = 'VeryLazy'
  }, -- highlight symbol under cursor

  -- language-specific plugins
  { 'Vimjas/vim-python-pep8-indent', ft = 'python', commit = '60ba5e11a61618c0344e2db190210145083c91f8' },

  { 'vim-ruby/vim-ruby' },
  { 'rodjek/vim-puppet' },
  {
    'windwp/nvim-autopairs',
    config = function()
       require('nvim-autopairs').setup({ fast_wrap = {}, enable_bracket_in_quote = true })
    end,
  }
}
