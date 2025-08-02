return {
  "tpope/vim-fugitive",
  enabled = false,
  config = function()
    vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
    vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
    vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
    vim.keymap.set("n", "<leader>ga", "<cmd>Gvdiff!<CR>")
    vim.keymap.set("v", "gal", "<cmd>diffput<CR>")
  end,
}
