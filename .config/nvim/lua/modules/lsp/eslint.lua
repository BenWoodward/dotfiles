local M = {
  setup = function(on_attach, capabilities)
    local lspconfig = require("lspconfig")

    lspconfig["eslint"].setup({
      root_dir = lspconfig.util.root_pattern(".eslintrc", ".eslintrc.js", ".eslintrc.json"),
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false

        on_attach(client, bufnr)
      end,
      capabilities = capabilities,
      settings = {
        format = {
          enable = true,
        },
      },
      handlers = {
        -- this error shows up occasionally when formatting
        -- formatting actually works, so this will supress it
        ["window/showMessageRequest"] = function(_, result)
          if result.message:find("ENOENT") then
            return vim.NIL
          end

          return vim.lsp.handlers["window/showMessageRequest"](nil, result)
        end,
      },
    })
    
    lspconfig.diagnosticls.setup {
      filetypes = {'javascript', 'typescript', 'svelte'},
      on_attach = function(client, bufnr)
        client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
      end,
    }
  end,
}

return M