return {
  { 'gracepetryk/rose-pine', priority = 2000, dev=true, lazy=false, config = function() require('plugins.colors') end},

  -- general
  { 'nvim-telescope/telescope.nvim',
    config = function() require('plugins.telescope') end,
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
    },
    event = 'VeryLazy'
  },
  { 'rmagatti/auto-session',
    config = function() require('auto-session').setup(require('plugins.session')) end,
    lazy=false,
  },

  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async'
    },
    event = 'VeryLazy'
  },

  -- treesitter
  { 'nvim-treesitter/nvim-treesitter',
    lazy = false,
    branch = 'main',
    build = ':TSUpdate',
    config = function() require 'plugins.treesitter' end
  },
  { 'nvim-treesitter/nvim-treesitter-context',
    event='VeryLazy',
    opts = {
      enabled = true,
      multiwindow = true,
      max_lines=5,
      mode='topline',
      trim_scope='inner',

    }
  },

  -- signs/folds
  { "luukvbaal/statuscol.nvim",
    lazy=false,
    config = function() require('plugins.statuscolumn') end,
  },

  -- git
  { 'tpope/vim-fugitive',
    event = 'VeryLazy',
    dependencies = {
      { 'tpope/vim-rhubarb' }, -- github
      { 'tommcdo/vim-fubitive' }, -- bitbucket
    },
  },
  { 'lewis6991/gitsigns.nvim',
    opts = require 'plugins.gitsigns', event = 'VeryLazy' },

  -- lsp
  { 'neovim/nvim-lspconfig' },
  { 'williamboman/mason.nvim' },
  { 'saghen/blink.cmp',
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
  { 'mfussenegger/nvim-dap',
    config = function() require 'plugins.dap' end,
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
              enabled = true,
              position = "left"
            }
          },
          windows = {
            terminal = {
              position = "right",
              hide = {},
              start_hidden = false
            }
          }
        },
      }
    }
  },

  -- editing
  { 'tpope/vim-sleuth' },
  { 'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },

  -- language-specific
  { 'nvim-java/nvim-java',
    ft = 'java',
    config = function() require('plugins.nvim_java') end,
    dependencies = {
      {'gracepetryk/nvim-java-test', branch = 'fork'},
    },
  },
  { 'rodjek/vim-puppet', ft = 'puppet' },
  { 'lepture/vim-jinja', ft = 'htmldjango' },
  { 'wavded/vim-stylus', ft = 'stylus'},
}
