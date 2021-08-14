-- vim: ts=2 sw=2 et:

local api       = vim.api
local lspconfig = require('lspconfig')
local util      = require('lspconfig.util')

local custom_attach = function(client, bufnr)
  local basics = require('lsp_basics')
  basics.make_lsp_commands(client, bufnr)
  basics.make_lsp_mappings(client, bufnr)

  nmap('gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
  nmap('gd', '<cmd>lua vim.lsp.buf.definitions()<cr>')
  nmap('K',  '<cmd>lua vim.lsp.buf.hover()<cr>')

  nmap('<Leader>gr', '<cmd>lua vim.lsp.buf.references()<cr>')
end

local custom_attach_svelte = function(client, bufnr)
  local basics = require('lsp_basics')
  basics.make_lsp_commands(client, bufnr)
  basics.make_lsp_mappings(client, bufnr)

  client.server_capabilities.completionProvider.triggerCharacters = {
    ".", "\"", "'", "`", "/", "@", "*",
    "#", "$", "+", "^", "(", "[", "-", ":",
  }

  nmap('gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
  nmap('gd', '<cmd>lua vim.lsp.buf.definitions()<cr>')
  nmap('K',  '<cmd>lua vim.lsp.buf.hover()<cr>')

  nmap('<Leader>gr', '<cmd>lua vim.lsp.buf.references()<cr>')

  local ts_utils = require("nvim-lsp-ts-utils")

  -- defaults
  ts_utils.setup {
    debug = false,
    disable_commands = false,
    enable_import_on_completion = false,
    import_all_timeout = 5000, -- ms

    -- eslint
    eslint_enable_code_actions = true,
    eslint_enable_disable_comments = true,
    eslint_bin = "eslint",
    eslint_config_fallback = nil,
    eslint_enable_diagnostics = false,

    -- formatting
    enable_formatting = true,
    formatter = "prettier",
    formatter_config_fallback = nil,

    -- parentheses completion
    complete_parens = false,
    signature_help_in_parens = false,

    -- update imports on file move
    update_imports_on_move = false,
    require_confirmation_on_move = false,
    watch_dir = nil,
  }

  -- required to fix code action ranges
  ts_utils.setup_client(client)
end

local function get_lua_runtime()
  local result = {}
  for _, path in pairs(api.nvim_list_runtime_paths()) do
    local lua_path = path .. '/lua/';
    if vim.fn.isdirectory(lua_path) then
      result[lua_path] = true
    end
  end
  result[vim.fn.expand('$VIMRUNTIME/lua')] = true
  return result;
end

local system_name = 'Linux'
local sumneko_root_path = vim.fn.expand('$HOME/github/lua-language-server')
local sumneko_binary = sumneko_root_path..'/bin/'..system_name..'/lua-language-server'

local servers = {
  svelte = {
    on_attach = custom_attach_svelte,
    filetypes = { 'svelte' },
    root_dir = util.root_pattern('package.json', '.git'),
    settings = {
      svelte = {
        plugin = {
          html   = { completions = { enable = true, emmet = false } },
          svelte = { completions = { enable = true, emmet = false } },
          css    = { completions = { enable = true, emmet = true  } },
        },
      },
    },
  },

  tsserver = {
    on_attach = custom_attach,
    filetypes = {'javascript', 'javascriptreact', 'javascript.jsx', 'typescript', 'typescriptreact', 'typescript.tsx'},
    root_dir = util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git')
  },
}

for server, config in pairs(servers) do
  lspconfig[server].setup(config)
end

