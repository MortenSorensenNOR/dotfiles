-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
-- vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.x',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use({
  	  'rose-pine/neovim',
  	  as = 'rose-pine',
  	  config = function()
  		  -- vim.cmd('colorscheme rose-pine')
  	  end
  })

  use 'shaunsingh/nord.nvim'
  use {'fcancelinha/northern.nvim'}
  use {
      'nvim-lualine/lualine.nvim',
      requires = { 'kyazdani42/nvim-web-devicons', opt = true }
  }


  use({
      "folke/trouble.nvim",
      config = function()
          require("trouble").setup {
              icons = true,
              -- your configuration comes here
              -- or leave it empty to use the default settings
              -- refer to the configuration section below
          }
      end
  })

  use {
      'nvim-treesitter/nvim-treesitter',
      run = function()
          local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
          ts_update()
      end
  }
  use("nvim-treesitter/playground")
  use("theprimeagen/harpoon")
  use("mbbill/undotree")
  use("tpope/vim-fugitive")
  use("nvim-treesitter/nvim-treesitter-context");

  use ({
      'williamboman/mason.nvim',
      config = function()
          require("mason").setup()
      end
  })
  use {'williamboman/mason-lspconfig.nvim'}

  -- LSP Support
  use {'neovim/nvim-lspconfig'}

  -- Autocompletion
  use {'hrsh7th/nvim-cmp'}
  use {'hrsh7th/cmp-nvim-lsp'}
  use {'L3MON4D3/LuaSnip'}

  use {'hrsh7th/cmp-nvim-lsp-signature-help'}

  use {'lervag/vimtex' }

  use("folke/zen-mode.nvim")
  use("eandrju/cellular-automaton.nvim")
  use("laytan/cloak.nvim")

  use("m4xshen/autoclose.nvim")

  use("terrortylor/nvim-comment")

  use({
      'MeanderingProgrammer/render-markdown.nvim',
      after = { 'nvim-treesitter' },
      requires = { 'echasnovski/mini.nvim', opt = true }, -- if you use the mini.nvim suite
      -- requires = { 'echasnovski/mini.icons', opt = true }, -- if you use standalone mini plugins
      -- requires = { 'nvim-tree/nvim-web-devicons', opt = true }, -- if you prefer nvim-web-devicons
  })
  

  use({
      'github/copilot.vim',
      config = function()
          -- Disable Copilot by default when starting Neovim
          vim.g.copilot_enabled = false
      end
  })

end)

