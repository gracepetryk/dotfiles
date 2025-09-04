return {
  { 'gracepetryk/rose-pine', priority = 2000, dev=true, lazy=false, config = function() require('plugins.colors') end},

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

  { 'lewis6991/gitsigns.nvim', opts = require 'plugins.gitsigns', event = 'VeryLazy' },

  { "luukvbaal/statuscol.nvim", config = function() require('plugins.statuscolumn') end },

  {
    'windwp/nvim-ts-autotag',
    lazy='VeryLazy',
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
    'nvim-telescope/telescope.nvim', config = function() require('plugins.telescope') end,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    event = 'VeryLazy'
  },

  {
    'rmagatti/auto-session',

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/Projects', '~/Downloads', '/' },
      cwd_change_handling=false,
      auto_restore_last_session=false,
      session_lens = {
        load_on_setup = false
      },
      priority=500,
      lazy=false
    }
  },


  { 'nvim-java/nvim-java' },
  { 'williamboman/mason.nvim' }, -- install LSPs/DAP/etc
  { 'williamboman/mason-lspconfig.nvim' }, -- install LSPs/DAP/etc
  { 'creativenull/efmls-configs-nvim' },
  {
    'neovim/nvim-lspconfig',
    config=function() require('plugins.lsp') end,
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
    lazy = false,
    keys = {
      '<C-b>',
      '<leader>d'
    },
    dependencies = {
      {
        'igorlfs/nvim-dap-view',
        opts={
          winbar = {
            controls = {
              enabled = true
            }
          },
          windows = {
            terminal = {
              position = "right",
              start_hidden = false
            }
          }
        },
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
      {
        '<leader>nt',
        function()
          require('nvim-tree.api').tree.open()
        end,
        desc="nvim-tree"
      }
    },
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts=require('plugins.tree')
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
}
