vim.g.mapleader = ' '

return require('lazy').setup({
  { 'tpope/vim-sleuth' }, -- detect indentation

  { 'tpope/vim-fugitive' }, -- git integration
  { 'tpope/vim-rhubarb' }, -- github integration
  {
    'lewis6991/gitsigns.nvim',
    config = function() require 'plugins.gitsigns' end,
    event = "CursorMoved"
  },

  --themes
  { 'Mofiqul/vscode.nvim'},
  -- use{'EdenEast/nightfox.nvim', opt=false},

  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'kyazdani42/nvim-web-devicons' },
    config = function() require 'plugins.statusline' end,
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
    'neovim/nvim-lspconfig',
    config = function() require 'plugins.lsp' end,
  }, -- Configurations for Nvim LSP

  {
    'hrsh7th/nvim-cmp',
    config = function() require 'plugins.completions' end,
    event = 'InsertEnter'
  },
  { 'hrsh7th/cmp-nvim-lsp', after = 'nvim-cmp' },
  { 'hrsh7th/cmp-nvim-lsp-signature-help', after = 'nvim-cmp' },
  {
    'jose-elias-alvarez/null-ls.nvim', -- allow non-lsp providers to hook into neovims lsp client (like flake8)
    config = function() require 'plugins.null-ls' end,
  },

  {
    'mfussenegger/nvim-dap',
    config = function() require 'plugins.dap' end,
    keys = {
      '<C-b>',
      '<leader><leader>d'
    },
  },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap' },
    after = { 'nvim-dap' },
    config = function() require 'plugins.dapui' end
  },

  {
    'rcarriga/cmp-dap',
    after = { 'nvim-cmp', 'nvim-dap', 'nvim-dap-ui' },
  },

  -- snippets
  { 'hrsh7th/vim-vsnip' },
  { 'hrsh7th/vim-vsnip-integ' },
  { 'hrsh7th/cmp-vsnip', after = 'nvim-cmp' },

  {
    'nvim-treesitter/nvim-treesitter',
    config = function() require 'plugins.treesitter' end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    config = function() require 'plugins.context' end,
    after = 'nvim-treesitter'
  },
  { 'nvim-treesitter/playground', after = 'nvim-treesitter' },

  -- language-specific plugins
  { 'Vimjas/vim-python-pep8-indent', ft='python' },
  { 'mitsuhiko/vim-jinja' },
  { 'iloginow/vim-stylus' },

  { 'ThePrimeagen/harpoon' },

  {
    'dstein64/vim-startuptime',
    cmd='StartupTime'
  },

  {
    'Shatur/neovim-session-manager',
    config = function() require 'plugins.sessions' end
  }
})
