-- vim: ts=2 sw=2 et:

local packer_ok, packer = pcall(require, "packer")
if not packer_ok then
  return
end

return packer.startup {
  {
    {
      'wbthomason/packer.nvim',
      opt = true,
    },

    {
      -- disable = true,
      'folke/tokyonight.nvim',
      config = function()
        vim.g.tokyonight_style            = 'storm' -- 'storm', 'night'  or 'day'
        vim.g.tokyonight_italic_comments  = true
        vim.g.tokyonight_italic_keywords  = false
        vim.g.tokyonight_italic_functions = false
        vim.g.tokyonight_italic_variables = false
        vim.g.tokyonight_transparent      = false
        vim.g.tokyonight_sidebars         = {'qf', 'vista_kind', 'terminal', 'packer'}
        vim.cmd [[colorscheme tokyonight]]
      end,
    },

    {'kyazdani42/nvim-web-devicons'},

    -- LSP
    {
      'neovim/nvim-lspconfig',
      config = function()
        require('modules.lsp')
      end,
      requires = {
        'jose-elias-alvarez/null-ls.nvim',
        'jose-elias-alvarez/nvim-lsp-ts-utils'
      },
    },

    {'nanotee/nvim-lsp-basics'},

    {
      'folke/trouble.nvim',
      requires = {
        'nvim-web-devicons'
      },
      config = function()
        require('plugins.config.trouble')
      end,
    },

    -- TreeSitter
    {
      'nvim-treesitter/nvim-treesitter',
      requires = {
        'nvim-treesitter/nvim-treesitter-refactor',
        'nvim-treesitter/nvim-treesitter-textobjects',
        'p00f/nvim-ts-rainbow',
        -- 'polarmutex/contextprint.nvim',
        'theHamsta/nvim-treesitter-pairs',
        'nvim-treesitter/playground',
      },
      run = ':TSUpdate',
      config = function()
        require('plugins.config.treesitter')
      end,
    },

    -- Git
    {
      'lewis6991/gitsigns.nvim',
      requires = {
        'nvim-lua/plenary.nvim'
      },
      config = function()
        require('plugins.config.gitsigns')
      end,
    },

    {
      'sindrets/diffview.nvim',
      requires = {'nvim-web-devicons'},
      config = function()
        require('plugins.config.diffview')
      end,
    },

    {'euclidianAce/BetterLua.vim'},

    -- Telescope
    {
      'nvim-telescope/telescope.nvim',
      requires = {
        'https://github.com/nvim-lua/popup.nvim',
        'https://github.com/nvim-lua/plenary.nvim',
        'https://github.com/nvim-telescope/telescope-project.nvim',
        {
          'https://github.com/nvim-telescope/telescope-smart-history.nvim',
          requires = {
            'tami5/sqlite.lua'
          }
        },
        'nvim-telescope/telescope-frecency.nvim',
        {
          'nvim-telescope/telescope-fzf-native.nvim',
          run = 'make'
        },
      },
      config = function()
        require('plugins.config.telescope')
      end,
    },

    {
      'terrortylor/nvim-comment',
      requires = {
        'JoosepAlviste/nvim-ts-context-commentstring'
      },
      config = function()
        require('plugins.config.comment')
      end,
    },

    {
      'norcalli/nvim-colorizer.lua',
      config = function()
        require('plugins.config.colorizer')
      end,
    },

    {'mg979/vim-visual-multi'},

    {'dstein64/nvim-scrollview'},

    -- Teal language support
    {'teal-language/vim-teal'},

    { "AndrewRadev/splitjoin.vim", keys = "gS" },

    {
      'folke/which-key.nvim',
      config = function()
        require('plugins.config.which-key')
      end,
    },

    {
      'ruifm/gitlinker.nvim',
      key = "gy",
      config = function()
        require('gitlinker').setup {
          mappings = "gy",
        }
      end,
    },

    {
      'L3MON4D3/LuaSnip',
      config = function()
        require 'plugins.config.luasnip'
      end,
    },

    {
      "hrsh7th/nvim-cmp",
      config = function()
        require "plugins.config.cmp"
      end,
      requires = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-vsnip",
        {
          "hrsh7th/vim-vsnip",
          setup = function()
            vim.cmd [[
            " Jump forward or backward
            imap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
            smap <expr> <C-j> vsnip#jumpable(1)  ? '<Plug>(vsnip-jump-next)' : '<C-j>'
            imap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
            smap <expr> <C-k> vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' : '<C-k>'
          ]]
          end,
        },
      },
    },

    -- Easier keymapping
    {
      'LionC/nest.nvim',
      config = function()
        require 'plugins.config.nest'
      end,
    },

    {
      "folke/zen-mode.nvim",
      config = function()
        require("zen-mode").setup {
          window = {
            width = .85 -- width will be 85% of the editor width
          }
        }
      end
    },

    { 'https://github.com/psliwka/vim-smoothie' },

    { 'https://github.com/voldikss/vim-floaterm' },

    { 'https://github.com/justinmk/vim-sneak' },

    -- I don't think this is necessary with treesitter installed?
    -- { 'https://github.com/evanleck/vim-svelte' },

    { 'https://github.com/Himujjal/tree-sitter-svelte' },

    { 'https://github.com/tpope/vim-surround' },

    { 
      'https://github.com/windwp/nvim-autopairs',
      config = function()
        require("nvim-autopairs").setup{}
      end
    },

    { 'https://github.com/andymass/vim-matchup' },

    { 
      'https://github.com/junegunn/fzf.vim',
      requires = {
        'https://github.com/junegunn/fzf',
        run = vim.fn['fzf#install'],
      }
    },

    { 'https://github.com/voldikss/vim-browser-search' },

    {
      "AckslD/nvim-neoclip.lua",
      config = function()
        require('neoclip').setup({
          history = 1000,
          enable_persistant_history = true,
          db_path = vim.fn.stdpath("data") .. "/databases/neoclip.sqlite3",
          filter = nil,
          preview = true,
          default_register = '"',
          content_spec_column = false,
          on_paste = {
            set_reg = false,
          },
          keys = {
            telescope = {
              i = {
                select = '<cr>',
                paste = '<c-p>',
                paste_behind = '<c-k>',
                custom = {},
              },
              n = {
                select = '<cr>',
                paste = 'p',
                paste_behind = 'P',
                custom = {},
              },
            },
          },
        })
      end,
      requires = {
        'tami5/sqlite.lua'
      }
    },
  },

  config = {
    compile_path = vim.fn.stdpath "data"
      .. "/site/pack/loader/start/packer.nvim/plugin/packer_compiled.lua",
    git = {
      clone_timeout = 300,
    },
    display = {
      open_fn = function()
        return require("packer.util").float { border = Util.borders }
      end,
    },
  },
}
