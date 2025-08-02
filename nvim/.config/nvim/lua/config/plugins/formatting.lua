return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        go = { "goimports", "gofmt" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        markdown = { "prettier" },
        gotmpl = { "prettier_go_template" },
        lua = { "stylua" },
        ["*"] = { "codespell" },
        sh = { "shfmt" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 3000,
      },

      formatters = {
        prettier_go_template = {
          command = "npx",
          args = {
            "prettier",
            "--parser",
            "go-template",
            "--tab-width",
            "4",
            "--stdin-filepath",
            "$FILENAME",
          },
          stdin = true,
          cwd = require("conform.util").root_file({
            "go.mod",
            "package.json",
            ".git",
          }),
        },
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>fa", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
