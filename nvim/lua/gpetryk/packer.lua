return require('packer').startup(function(use)
  -- Packer can manage itself
  use('wbthomason/packer.nvim')

  use('dstein64/vim-startuptime')

  use('ggandor/leap.nvim')

  use('tpope/vim-fugitive')
  use('tpope/vim-rhubarb')
  use('lewis6991/gitsigns.nvim')
  use('f-person/git-blame.nvim')

  use('Mofiqul/vscode.nvim')
  use('folke/tokyonight.nvim')
  use('catppuccin/nvim')
  use('jacoborus/tender.vim')
  use('patstockwell/vim-monokai-tasty')

  use({
    "folke/noice.nvim",
    requires = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- "rcarriga/nvim-notify"
    }
  })

  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }

  use('nvim-tree/nvim-web-devicons')
  use('akinsho/bufferline.nvim')
  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use('neovim/nvim-lspconfig') -- Configurations for Nvim LSP
  use('hrsh7th/cmp-nvim-lsp')
  use('hrsh7th/cmp-buffer')
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp-signature-help')
  use('L3MON4D3/LuaSnip')
  use('onsails/lspkind.nvim')


  use {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end,
  }

  use('mfussenegger/nvim-dap')
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
  use('rcarriga/cmp-dap')

  use('jose-elias-alvarez/null-ls.nvim')

  use('Shatur/neovim-session-manager')

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use('nvim-treesitter/nvim-treesitter-context')

  use('Vimjas/vim-python-pep8-indent')
end)
