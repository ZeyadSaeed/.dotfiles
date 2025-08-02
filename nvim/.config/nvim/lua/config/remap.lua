local set = vim.keymap.set

vim.g.mapleader = " "
set("n", "<leader>pv", vim.cmd.Ex)
set("n", "<leader>spv", vim.cmd.Vex)

set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = "Execute the current file" })

set("v", "J", ":m '>+1<CR>gv=gv")
set("v", "K", ":m '<-2<CR>gv=gv")

set("n", "J", "mzJ`z")
set("n", "<C-d>", "<C-d>zz")
set("n", "<C-u", "<C-u>zz")
set("n", "n", "nzzzv")
set("n", "N", "Nzzzv")

set("n", "<leader>o", "o<Esc>")
set("n", "<leader>O", "O<Esc>")

set("x", "<leader>vp", "\"_dP")
-- set("n", "<leader>pc", "\"+p")
-- set("v", "<leader>pc", "\"+p")
--
-- set("n", "<leader>y", "\"+y")
-- set("v", "<leader>y", "\"+y")
-- set("n", "<leader>Y", "\"+Y")

set("n", "<leader>d", "\"_d")
set("v", "<leader>d", "\"_d")

set("i", "<C-c>", "<Esc>")

vim.g.ftplugin_sql_omni_key = '<C-j>'

vim.g['prettier#config#config_precedence'] = 'file-override'

set("n", "Q", "<nop>")
set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

set("n", "<leader>s", [[:%s/\<<c-r><c-w>\>/<c-r><c-w>/gi<left><left><left>]])

set("n", "<C-j>", "<cmd>cnext<CR>")
set("n", "<C-k>", "<cmd>cprev<CR>")

set("n", "<leader>st", function()
  vim.cmd.vnew()
  vim.cmd.term()
  vim.cmd.wincmd("J")
  vim.api.nvim_win_set_height(0, 15)
end)

set("n", "-", "<cmd>Oil<CR>")
set("t", "<esc><esc>", "<c-\\><c-n>")

set('n', '<leader>1', '1gt')
set('n', '<leader>2', '2gt')
set('n', '<leader>3', '3gt')
set('n', '<leader>4', '4gt')
set('n', '<leader>5', '5gt')
set('n', '<leader>6', '6gt')
