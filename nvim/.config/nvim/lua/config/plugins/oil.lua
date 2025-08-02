return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    opts = {
      view_options = {
        show_hidden = true,
        is_always_hidden = function(name)
          if name:match('%.git$') then
            return true
          end
          return false
        end,
      },
    },
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
    config = function()
      require("oil").setup({
        keymaps = {
          ["<C-v>"] = { "actions.select", opts = { vertical = true } },
        }
      })
      vim.keymap.set("n", "<leader>oe", function()
        require("oil").toggle_float()
      end, { desc = "Open Oil on current file's directory" })
    end
  }
}
