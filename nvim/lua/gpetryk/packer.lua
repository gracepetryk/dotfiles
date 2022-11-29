return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'tpope/vim-fugitive'
    use 'jreybert/vimagit'
    use 'airblade/vim-gitgutter'

    use 'folke/tokyonight.nvim'

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }

    use 'nvim-tree/nvim-web-devicons'
    use {'romgrk/barbar.nvim', wants = 'nvim-web-devicons'}

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    use('neovim/nvim-lspconfig') -- Configurations for Nvim LSP
    use("hrsh7th/cmp-nvim-lsp")
    use("hrsh7th/cmp-buffer")
    use("glepnir/lspsaga.nvim")
    use("ray-x/lsp_signature.nvim")
    use("hrsh7th/nvim-cmp")

    use 'Shatur/neovim-session-manager'

    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }

    use 'voldikss/vim-floaterm'

    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons', -- optional, for file icons
        }
    }
end)
