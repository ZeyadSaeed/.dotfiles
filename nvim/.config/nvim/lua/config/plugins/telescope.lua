return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
  },
  config = function()
    require("telescope").setup({
      extensions = {
        fzf = {}
      }
    })
    require("telescope").load_extension('fzf')

    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<C-p>', builtin.git_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope find files' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope find help tags' })
    vim.keymap.set('n', '<leader>fcw', function()
      local word = vim.fn.expand("<cword>")
      builtin.grep_string({ search = word })
    end)
    vim.keymap.set('n', '<leader>fn', function()
      builtin.find_files({
        cmd = vim.fn.stdpath("config")
      })
    end)
  end
}
