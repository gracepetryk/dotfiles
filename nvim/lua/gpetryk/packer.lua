return require('packer').startup({function(use)
  -- Packer can manage itself
  use('wbthomason/packer.nvim')

  use('ggandor/leap.nvim') -- s jumping

  use('tpope/vim-sleuth') -- detect indentation

  use('tpope/vim-fugitive') -- git integration
  use('tpope/vim-rhubarb') -- github integration
  use('lewis6991/gitsigns.nvim')

  --themes
  use('Mofiqul/vscode.nvim')
  use('folke/tokyonight.nvim')
  use('catppuccin/nvim')
  use('jacoborus/tender.vim')
  use('patstockwell/vim-monokai-tasty')

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
  use('hrsh7th/nvim-cmp')
  use('hrsh7th/cmp-nvim-lsp-signature-help')
  use('j-hui/fidget.nvim') -- lsp status notifications
  use('jose-elias-alvarez/null-ls.nvim') -- allow non-lsp providers to hook into neovims lsp client (like flake8)

  use {
    "smjonas/inc-rename.nvim",
    config = function()
      require("inc_rename").setup()
    end,
  }

  use('mfussenegger/nvim-dap')
  use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
  use('rcarriga/cmp-dap')

  -- snippets
  use('hrsh7th/vim-vsnip')
  use('hrsh7th/vim-vsnip-integ')
  use('hrsh7th/cmp-vsnip')

  use('Shatur/neovim-session-manager')

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }
  use('nvim-treesitter/nvim-treesitter-context')

  -- language-specific plugins
  use('Vimjas/vim-python-pep8-indent')
  use('mitsuhiko/vim-jinja')
  use('iloginow/vim-stylus')
end,
config = {
  profile = {
    enable = true,
    threshold = 1 -- the amount in ms that a plugin's load time must be over for it to be included in the profile
  }
}})
