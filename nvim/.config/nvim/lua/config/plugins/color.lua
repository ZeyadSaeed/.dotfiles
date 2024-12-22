return {
  {
    "oxfist/night-owl.nvim",
    priority = 1000,
    config = function()
      require("night-owl").setup()
      vim.cmd.colorscheme("night-owl")
    end
  }
}
