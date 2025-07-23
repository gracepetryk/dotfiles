return {
  { 'gracepetryk/rose-pine', priority = 2000, dev=true, config = function() require 'plugins.colors' end, lazy=false},

  { 'tpope/vim-sleuth' },
  { 'tpope/vim-repeat' },
  {
    'tpope/vim-fugitive', -- git integration
    event = 'VeryLazy',
    dependencies = {
      { 'tpope/vim-rhubarb' }, -- github
      { 'tommcdo/vim-fubitive' }, -- bitbucket
    },
  },

  { 'lewis6991/gitsigns.nvim', config = function() require 'plugins.gitsigns' end, event = 'VeryLazy' },

  {
    'windwp/nvim-ts-autotag',
    lazy=false,
    opts = {
      opts = {
        enable_rename = true
      }
    }
  },

  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },


  {
    'nvim-telescope/telescope.nvim', config = function() require 'plugins.telescope' end,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' }
    },
    event = 'VeryLazy'
  },

  {
    'rmagatti/auto-session',

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      cwd_change_handling=false,
      auto_restore_last_session=false,
      session_lens = {
        load_on_setup = false
      },
      priority=500,
      lazy=false
    }
  },


  { 'williamboman/mason.nvim', lazy=true, cmd='Mason' }, -- install LSPs/DAP/etc
  { 'creativenull/efmls-configs-nvim', lazy=true },
  {
    'neovim/nvim-lspconfig',
    config= function() require 'plugins.lsp' end,
    lazy=false
  },

  {
    'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = 'rafamadriz/friendly-snippets',

    -- use a release tag to download pre-built binaries
    version = '*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    opts = require('plugins.cmp'),
    opts_extend = { "sources.default" },
    event = 'InsertEnter'
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
      }
    }
  },

  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function() require 'plugins.treesitter' end
  },

  {
    'nvim-treesitter/nvim-treesitter-context',
    event='VeryLazy',
    opts = {
      enabled = true,
      multiwindow = true,
      max_lines=5,
      mode='topline',
      trim_scope='inner',

    }
  },

  {
    'nvim-tree/nvim-tree.lua',
    dev=true,
    keys = {
      '<leader>nt'
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function ()
      require('plugins.tree')
    end
  },

  { 'rodjek/vim-puppet', event = 'VeryLazy' },
  { 'lepture/vim-jinja' },
  {
    'norcalli/nvim-colorizer.lua',
    enabled = false,
    event = 'VeryLazy',
    main = 'colorizer',
    opts = { lua = {mode = 'foreground'} },
    opts_extend = { mode = 'foreground' }
  },

  { 'wavded/vim-stylus' },
  { 'mfussenegger/nvim-jdtls', lazy=true, config=false }
}
