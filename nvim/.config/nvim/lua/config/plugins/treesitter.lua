return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    build = ":TSUpdate",
    config = function()
      vim.treesitter.language.register("yaml", "cloudformation")
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "go",
          "gotmpl",
          "helm",
          "sql",
          "json",
          "javascript",
          "typescript",
          "tsx",
          "yaml",
          "html",
          "css",
          "markdown",
          "markdown_inline",
          "bash",
          "lua",
          "vim",
          "dockerfile",
          "gitignore",
          "query",
          "vimdoc",
          "c",
          "terraform",
          "hcl",
        },
        auto_install = true,
        sync_install = false,
        ignore_install = {},
        modules = {},
        indent = { enable = true },
        incremental_selection = { enable = true },
        autotag = { enable = true },
        highlight = {
          enable = true,
          disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              return true
            end
          end,
        },
      })

      vim.filetype.add({
        extension = {
          tmpl = "gotmpl",
        },
        pattern = {
          [".*/templates/.*%.tpl"] = "helm",
          [".*/templates/.*%.ya?ml"] = "helm",
          ["helmfile.*%.ya?ml"] = "helm",
        },
      })

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "Caddyfile",
        callback = function()
          vim.bo.filetype = "caddy"
        end,
      })
    end,
  },
}
