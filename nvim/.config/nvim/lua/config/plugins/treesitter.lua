return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").install({
        "go",
        --  "gotmpl",
        --  "helm",
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
      })

      vim.treesitter.language.register("yaml", "cloudformation")

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(ev)
          local max_filesize = 100 * 1024
          local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
          if ok and stats and stats.size > max_filesize then
            return
          end
          pcall(vim.treesitter.start)
        end,
      })

      -- Indentation (replaces indent.enable = true)
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
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

      require("nvim-ts-autotag").setup()
    end,
  },
}
