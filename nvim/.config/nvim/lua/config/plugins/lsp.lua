return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  "williamboman/mason.nvim",
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { 'saghen/blink.cmp' },
    config = function()
      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = { 'lua_ls', 'eslint', 'tailwindcss', 'ts_ls' },
        handlers = {
          function(server_name)
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            require('lspconfig')[server_name].setup({ capabilities = capabilities })
          end,


          rust_analyzer = function()
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            require('lspconfig').rust_analyzer.setup({
              capabilities = capabilities,
              settings = {
                ['rust-analyzer'] = {
                  assist = {
                    importEnforceGranularity = true,
                    importPrefix = 'crate',
                  },
                  cargo = {
                    allFeatures = true,
                  },
                  checkOnSave = {
                    command = 'clippy',
                  },
                  inlayHints = { locationLinks = false },
                  diagnostics = {
                    enable = true,
                    experimental = {
                      enable = true,
                    },
                  },
                },
              },
            })
          end,

          lua_ls = function()
            local capabilities = require('blink.cmp').get_lsp_capabilities()
            require('lspconfig').lua_ls.setup({
              capabilities = capabilities,
              settings = {
                Lua = {
                  diagnostics = {
                    globals = { 'vim' }
                  }
                }
              }
            })
          end,
        }
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require('blink.cmp').get_lsp_capabilities()
      require('lspconfig').lua_ls.setup({
        capabilities = capabilities,
      })
      -- Auto format on save
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          --          local client = vim.lsp.get_client_by_id(args.data.client_id)
          --          if not client then end;
          --
          --          if client and client.supports_method('textDocument/formating') then
          --            vim.api.nvim_create_autocmd('BufWritePre', {
          --              buffer = args.buf,
          --              callback = function()
          --                vim.lsp.buf.format({ bufnr = args.buf, id = client.id })
          --              end
          --            })
          --          end

          -- LSP Remaps
          local opts = { buffer = args.buf, remap = false }

          vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
          vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
          vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
          vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
          vim.keymap.set("n", "<leader>od", function() vim.diagnostic.setqflist() end, opts)
          vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
          vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
          vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
          vim.keymap.set("n", "<leader>fa", function() vim.lsp.buf.format() end, opts)
          vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        end
      })
    end
  },
}
