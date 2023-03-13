return {
  -- better vim.ui
  {
    "stevearc/dressing.nvim",
    lazy = true,
    init = function()
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.select = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.select(...)
      end
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.ui.input = function(...)
        require("lazy").load({ plugins = { "dressing.nvim" } })
        return vim.ui.input(...)
      end
    end,
  },

  -- indent guides for Neovim
  {
    "lukas-reineke/indent-blankline.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      -- char = "▏",
      char = "│",
      filetype_exclude = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy" },
      show_trailing_blankline_indent = false,
      show_current_context = false,
    },
  },

  -- active indent guide and indent text objects
  {
    "echasnovski/mini.indentscope",
    version = false, -- wait till new 0.7.0 release to put it back on semver
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- symbol = "▏",
      symbol = "│",
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "help", "alpha", "dashboard", "neo-tree", "Trouble", "lazy", "mason" },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
    config = function(_, opts)
      require("mini.indentscope").setup(opts)
    end,
  },

  -- icons
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- ui components
  { "MunifTanjim/nui.nvim", lazy = true },

  {
    'https://github.com/NvChad/nvim-colorizer.lua',
    config = function()
      require("colorizer").setup {
        filetypes = { "*" },
        user_default_options = {
          RGB = true, -- #RGB hex codes
          RRGGBB = true, -- #RRGGBB hex codes
          names = true, -- "Name" codes like Blue or blue
          RRGGBBAA = false, -- #RRGGBBAA hex codes
          AARRGGBB = false, -- 0xAARRGGBB hex codes
          rgb_fn = false, -- CSS rgb() and rgba() functions
          hsl_fn = false, -- CSS hsl() and hsla() functions
          css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
          css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
          -- Available modes for `mode`: foreground, background,  virtualtext
          mode = "background", -- Set the display mode.
          -- Available methods are false / true / "normal" / "lsp" / "both"
          -- True is same as normal
          tailwind = true, -- Enable tailwind colors
          -- parsers can contain values used in |user_default_options|
          sass = { enable = false, parsers = { css }, }, -- Enable sass colors
          virtualtext = "■",
        },
        -- all the sub-options of filetypes apply to buftypes
        buftypes = {},
    }
    end,
  }, 

  {'https://github.com/mg979/vim-visual-multi'},

  {'https://github.com/dstein64/nvim-scrollview'},

  { 'https://github.com/psliwka/vim-smoothie' }, 

  { 'https://github.com/voldikss/vim-floaterm' }, -- used for ranger / lf

  {
    'https://github.com/WhoIsSethDaniel/toggle-lsp-diagnostics.nvim',
    config = function()
      require'toggle_lsp_diagnostics'.init({ all = true, start_on = true })
    end
  },

  { 
    'https://github.com/akinsho/toggleterm.nvim',
    config = function()
      local status_ok, toggleterm = pcall(require, "toggleterm")
      if not status_ok then
        return
      end
      toggleterm.setup({
        size = 10,
        open_mapping = [[<c-\>]],
        shading_factor = 2,
        direction = "float",
        float_opts = {
          border = "curved",
          highlights = {
            border = "Normal",
            background = "Normal",
          },
        },
      })


      function _G.set_terminal_keymaps()
        local opts = {noremap = true}

        if vim.fn.mapcheck("<Esc>", "t") ~= "" then
          vim.api.nvim_del_keymap("t", "<Esc>")
        end
      end

      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end
  },

  {
    'https://github.com/kevinhwang91/nvim-ufo',
    dependencies = {
      'https://github.com/kevinhwang91/promise-async'
    },
    config = function()
      -- TODO: https://github.com/kevinhwang91/nvim-ufo/issues/4
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      -- vim.o.foldcolumn = '5'
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- TODO: move these to nest.lua
      -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself
      vim.keymap.set('n', 'zR', require('ufo').openAllFolds)
      vim.keymap.set('n', 'zM', require('ufo').closeAllFolds)
      vim.keymap.set('n', 'zr', require('ufo').openFoldsExceptKinds)
      vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith) -- closeAllFolds == closeFoldsWith(0)
      vim.keymap.set('n', 'K', function()
          local winid = require('ufo').peekFoldedLinesUnderCursor()
          if not winid then
              -- choose one of coc.nvim and nvim lsp
              vim.lsp.buf.hover()
          end
      end)

      -- Option 3: treesitter as a main provider instead
      -- Only depend on `nvim-treesitter/queries/filetype/folds.scm`,
      -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
      require('ufo').setup({
        provider_selector = function(bufnr, filetype, buftype)
          return {'treesitter', 'indent'}
        end,
        preview = {
          win_config = {
            winblend = 0,
            winhighlight = 'NormalFloat:FoldPreview,FloatBorder:FoldPreviewBorder'
          },
          mappings = {
              scrollU = '<C-u>',
              scrollD = '<C-d>'
          },
        }
      })
    end
  },

  { 
    "anuvyklack/windows.nvim",
    dependencies = {
      "anuvyklack/middleclass",
      "anuvyklack/animation.nvim"
    },
    config = function()
      vim.o.winwidth = 10
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require('windows').setup()
    end
  },

}