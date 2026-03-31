return {
  "nvim-lualine/lualine.nvim",
  opts = {
    sections = {
      lualine_c = { require("doing").status },
    },
  },
}
