--return {
--  "hrsh7th/nvim-cmp",
--  event = "InsertEnter",
--  dependencies = {
--    "hrsh7th/cmp-buffer", -- source for text in buffer
--    "hrsh7th/cmp-path", -- source for file system paths
--    {
--      "L3MON4D3/LuaSnip",
--      -- follow latest release.
--      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
--      -- install jsregexp (optional!).
--      build = "make install_jsregexp",
--    },
--    "saadparwaiz1/cmp_luasnip", -- for autocompletion
--    "rafamadriz/friendly-snippets", -- useful snippets
--    "onsails/lspkind.nvim", -- vs-code like pictograms
--  },
--  config = function()
--    local cmp = require("cmp")
--    local luasnip = require("luasnip")
--    local lspkind = require("lspkind")
--
--    require("luasnip.loaders.from_vscode").lazy_load()
--    require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/snippets" } })
--
--    cmp.setup({
--      preselect = "None",
--      snippet = { -- configure how nvim-cmp interacts with snippet engine
--        expand = function(args)
--          luasnip.lsp_expand(args.body)
--        end,
--      },
--      mapping = cmp.mapping.preset.insert({
--        ["<C-p>"] = cmp.mapping.select_prev_item(),
--        ["<C-n>"] = cmp.mapping.select_next_item(),
--        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
--        ["<C-Space>"] = cmp.mapping.complete(),
--      }),
--      -- sources for autocompletion
--      sources = cmp.config.sources({
--        { name = "nvim_lsp", priority_weight = 1000 }, -- lsp
--        { name = "luasnip", priority_weight = 750 }, -- snippets
--        { name = "buffer", priority_weight = 500 }, -- text within current buffer
--        { name = "path", priority_weight = 250 }, -- file system paths
--      }),
--
--      sorting = {
--        priority_weight = 2,
--        comparators = {
--          cmp.config.compare.offset,
--          cmp.config.compare.exact,
--          cmp.config.compare.score,
--          cmp.config.compare.recently_used,
--          cmp.config.compare.locality,
--          cmp.config.compare.kind,
--          cmp.config.compare.length,
--          cmp.config.compare.order,
--        },
--      },
--
--      -- configure lspkind for vs-code like pictograms in completion menu
--      formatting = {
--        format = lspkind.cmp_format({
--          maxwidth = 50,
--          ellipsis_char = "...",
--        }),
--      },
--    })
--  end,
--}
return {
  "saghen/blink.cmp",
  dependencies = { "rafamadriz/friendly-snippets" },
  version = "1.*",
  opts = {
    keymap = { preset = "default" },
    completion = {
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 0,
      },
      menu = {
        draw = {
          columns = {
            { "label", "label_description", gap = 1 },
            { "kind_icon", "kind" },
          },
          treesitter = { "lsp" },
        },
      },
    },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    signature = {
      enabled = true,
      window = {
        show_documentation = true,
      },
    },
  },
  opts_extend = { "sources.default" },
}
