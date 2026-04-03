return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      go = { "golangcilint" },
      sh = { "shellcheck" },
      yml = { "yamllint" },
      yaml = { "yamllint" },
      json = { "eslint_d" },
      cloudformation = { "cfn_lint" },
      dockerfile = { "hadolint" },
      -- tf = { "terraform_validate", "tflint", "tfsec" },
    }

    -- Optional: Enhanced CloudFormation detection based on content
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = "*.{yml,yaml,json}",
      callback = function()
        local lines = vim.api.nvim_buf_get_lines(0, 0, 50, false) -- Check first 50 lines
        for _, line in ipairs(lines) do
          if
            line:match("AWSTemplateFormatVersion")
            or line:match("Transform.*AWS::Serverless")
            or line:match("Resources:") and vim.fn.search("Type:.*AWS::", "n") > 0
          then
            vim.bo.filetype = "cloudformation"
            break
          end
        end
      end,
    })

    -- CloudFormation Setup
    lint.linters.cfn_lint = {
      name = "cfn_lint",
      cmd = "cfn-lint",
      stdin = true,
      args = {
        "--format",
        "parseable",
        "--include-checks",
        "I", -- Include informational checks
        "--", -- Read from stdin
      },
      stream = "stdout",
      ignore_exitcode = true,
      parser = function(output, bufnr)
        local diagnostics = {}
        for line in output:gmatch("[^\r\n]+") do
          -- Parse cfn-lint output format: filename:line:column:level:code:message
          local file, lnum, col, level, code, message = line:match("(.+):(%d+):(%d+):(%w+):([^:]+):(.+)")
          if lnum and col and level and message then
            local severity = vim.diagnostic.severity.ERROR
            if level == "W" or level == "Warning" then
              severity = vim.diagnostic.severity.WARN
            elseif level == "I" or level == "Informational" then
              severity = vim.diagnostic.severity.INFO
            end

            table.insert(diagnostics, {
              lnum = tonumber(lnum) - 1,
              col = tonumber(col) - 1,
              end_lnum = tonumber(lnum) - 1,
              end_col = tonumber(col),
              severity = severity,
              message = string.format("[%s] %s", code or "", message or ""),
              source = "cfn-lint",
            })
          end
        end
        return diagnostics
      end,
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    local function try_linting()
      -- Get the current buffer's filename
      local filename = vim.fn.expand("%:t")

      -- Skip linting for .env files
      if filename == ".env" or filename:match("^%.env%.") then
        return
      end

      local linters = lint.linters_by_ft[vim.bo.filetype]
      lint.try_lint(linters)
    end

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        try_linting()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      try_linting()
    end, { desc = "Trigger linting for current file" })
  end,
}
