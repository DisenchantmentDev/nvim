return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    require("bufferline").setup({})
    vim.keymap.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>")
    vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>")
  end,
}
