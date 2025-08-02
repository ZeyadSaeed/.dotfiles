return {
  "gbprod/substitute.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local substitute = require("substitute")

    substitute.setup()

    -- set keymaps
    vim.keymap.set("n", "<leader>r", substitute.operator, { desc = "Substitute with motion" })
    vim.keymap.set("n", "<leader>rr", substitute.line, { desc = "Substitute line" })
    vim.keymap.set("x", "<leader>r", substitute.visual, { desc = "Substitute in visual mode" })
  end,
}
