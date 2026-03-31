return {
  "Hashino/doing.nvim",
  lazy = false,
  opts = {
    winbar = {
      enabled = false,
    },
  },
  keys = {
    {
      "<leader>da",
      function()
        require("doing").add()
      end,
      desc = "[D]oing: [A]dd",
    },
    {
      "<leader>dn",
      function()
        require("doing").done()
      end,
      desc = "[D]oing: Do[n]e",
    },
    {
      "<leader>de",
      function()
        require("doing").edit()
      end,
      desc = "[D]oing: [E]dit",
    },
  },
}
