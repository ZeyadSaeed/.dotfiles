return {
  {
    "williamboman/mason.nvim",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      require("mason").setup({})
      require("mason-lspconfig").setup({
        automatic_enable = true,
      })

      require("mason-tool-installer").setup({
        ensure_installed = {
          -- Lsp servers
          "ts_ls",
          "html",
          "cssls",
          "tailwindcss",
          "lua_ls",
          "emmet_ls",
          "eslint",
          "gopls",
          "bashls",
          "terraformls",

          -- Formatters and linters
          "stylua", -- lua formatter
          "eslint_d",
          "goimports",
          "prettier",
          "golangci-lint",
          "shellcheck",
          "shfmt",
          "hadolint",
          "cfn-lint",
          "tflint",
          "tfsec",
        },
      })
    end,
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "saghen/blink.cmp",
      { "antosha417/nvim-lsp-file-operations", config = true },
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.diagnostic.config({
        virtual_text = true,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })

      -- Apply capabilities to all servers via the new vim.lsp.config API
      vim.lsp.config("*", { capabilities = capabilities })

      vim.lsp.config("emmet_ls", {
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
      })

      vim.lsp.config("eslint", {
        filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
      })

      vim.lsp.config("ts_ls", {
        settings = {
          javascript = {
            suggest = { completeFunctionCalls = false },
          },
          typescript = {
            suggest = { completeFunctionCalls = false },
          },
        },
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
          local opts = { buffer = args.buf, remap = false, silent = true }

          vim.keymap.set("n", "gd", function()
            vim.lsp.buf.definition()
          end, opts)
          vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover()
          end, opts)
          vim.keymap.set("n", "<leader>vws", function()
            vim.lsp.buf.workspace_symbol()
          end, opts)
          vim.keymap.set("n", "<leader>e", function()
            vim.diagnostic.open_float()
          end, opts)
          vim.keymap.set("n", "<leader>q", function()
            vim.diagnostic.setqflist()
          end, opts)
          vim.keymap.set("n", "<leader>vca", function()
            vim.lsp.buf.code_action()
          end, opts)
          vim.keymap.set("n", "<leader>vrr", function()
            vim.lsp.buf.references()
          end, opts)
          vim.keymap.set("n", "<leader>vrn", function()
            vim.lsp.buf.rename()
          end, opts)
          vim.keymap.set("i", "<C-h>", function()
            vim.lsp.buf.signature_help()
          end, opts)
        end,
      })
    end,
  },
}
