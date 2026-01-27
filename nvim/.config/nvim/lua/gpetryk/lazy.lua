local function load_config(module)
  return function ()
    require(module)
  end
end

return {
  { 'gracepetryk/rose-pine', dev=true, branch='custom', lazy=false, config = load_config('plugins.colors')},

  -- general
  {
    'folke/zen-mode.nvim',
    keys = {
      { "<leader>Z", "<cmd>ZenMode<cr>"}
    },
    init = function (...)
      vim.api.nvim_create_autocmd('ExitPre', {
        callback = function ()
          vim.schedule(function ()
            require('zen-mode').close()
          end)
        end
      })
    end,
    opts = {
      window = {
        backdrop = 1,
        options = {
          signcolumn = "no", -- disable signcolumn
          number = false, -- disable number column
          relativenumber = true, -- disable relative numbers
          cursorline = false, -- disable cursorline
          cursorcolumn = false, -- disable cursor column
          foldcolumn = "0", -- disable fold column
          list = false, -- disable whitespace characters
        },
      },
      plugins = {
        kitty = {
          enabled = true,
          font = "+2"
        }
      }
    }
  },
  {
    'nvim-telescope/telescope.nvim',
    config = load_config('plugins.telescope'),
    dependencies = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    event = 'VeryLazy'
  },
  {
    'rmagatti/auto-session',

    config = function() require('auto-session').setup(require('plugins.session')) end,
    lazy=false,
    priority = 110
  },

  { 'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async'
    },
    event = 'VeryLazy',
    config = load_config('plugins.folds')
  },

  -- treesitter
  { 'nvim-treesitter/nvim-treesitter',
    lazy = false,
    priority=100,
    branch = 'main',
    build = ':TSUpdate',
    config = load_config("plugins.treesitter")
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
    config = load_config('plugins.statuscolumn'),
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
  { 'neovim/nvim-lspconfig', config = load_config('plugins.lsp') },
  { 'williamboman/mason.nvim' },
  { 'saghen/blink.cmp',
    -- optional: provides snippets for the snippet source
    dependencies = {
      'rafamadriz/friendly-snippets',
      { 'onsails/lspkind.nvim', lazy=true },
      { 'nvim-mini/mini.icons', lazy=true },
    },

    -- use a release tag to download pre-built binaries
    version = '*',
    -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
    -- build = 'cargo build --release',
    -- If you use nix, you can build from source using latest nightly rust with:
    -- build = 'nix run .#build-plugin',

    opts = require('plugins.cmp'),
    opts_extend = { "sources.default" },
    event = {'InsertEnter', 'CmdlineEnter'}
  },
  { 'mfussenegger/nvim-dap',
    config = load_config('plugins.dap'),
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

  -- llm
  { "coder/claudecode.nvim",
    ---@type PartialClaudeCodeConfig
    opts = {
      ---@class _: ClaudeCodeTerminalConfig
      terminal = {
        ---@module "snacks"
        ---@type snacks.win.Config
        snacks_win_opts = {
          position = "right",
          width=0.3,
          backdrop = false,
          style = "terminal",
          wo = {
            winhighlight = "NormalFloat:Normal",
          }
        }
      }
    },
    keys = {
      { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>cf", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>cC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>cs", "<cmd>ClaudeCodeSend<cr><cmd>sleep 10ms<cr><cmd>ClaudeCodeOpen<cr>", mode = "v", desc = "Send to Claude" },
      { "<leader>cs", "V<cmd>ClaudeCodeSend<cr><cmd>sleep 10ms<cr><cmd>ClaudeCodeOpen<cr>", mode = "n", desc = "Send to Claude" },
      {
        "<leader>cs",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>ca", "<cmd>ClaudeCodeDiffAccept<cr><cmd>ClaudeCodeFocus<cr>", desc = "Accept diff" },
      { "<leader>cd", "<cmd>ClaudeCodeDiffDeny<cr><cmd>ClaudeCodeFocus<cr>", desc = "Deny diff" },
    },
    dependencies = { "folke/snacks.nvim" }
  },

  -- language-specific
  { 'nvim-java/nvim-java',
    ft = 'java',
    config = load_config('plugins.nvim_java'),
    dependencies = {
      {'gracepetryk/nvim-java-test', branch = 'fork'},
    },
  },
  { 'rodjek/vim-puppet', ft = 'puppet' },
  { 'lepture/vim-jinja', ft = 'htmldjango' },
  { 'wavded/vim-stylus', ft = 'stylus'},
  { 'kristijanhusak/vim-dadbod-ui', ft = 'sql',
    dependencies = {
      { 'tpope/vim-dadbod', lazy = true },
      { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true }, -- Optional
    },
    cmd = {
      'DBUI',
      'DBUIToggle',
      'DBUIAddConnection',
      'DBUIFindBuffer',
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  { 'chrisbra/Colorizer' },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
    ft = {'markdown', 'python'},
    opts = {
      patterns = {
        -- Highlight patterns to disable for filetypes, i.e. lines concealed around code blocks

        markdown = {
          disable = true,
          directives = {
            { id = 17, name = 'conceal_lines' },
            { id = 18, name = 'conceal_lines' },
          },
        },
      },
      sign = { enabled = true },
      code = {
        sign = false,
        width = 'block',
        right_pad = 4,
      },
      heading = {
        width = 'block'
      },
      completions = { lsp = {enabled = false}},
      anti_conceal = { enabled = true},
      win_options = {
        concealcursor = { rendered = 'n' },
        conceallevel = { rendered = 1 },
      }
    }
  },

}
