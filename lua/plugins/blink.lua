return {
  "saghen/blink.cmp",
  opts = {
    enabled = function()
      local disabled = false
      local success, node = pcall(vim.treesitter.get_node)
      disabled = disabled or (vim.bo.buftype == "prmpt")
      disabled = disabled or (vim.fn.reg_recording() ~= "")
      disabled = disabled or (vim.fn.reg_executing() ~= "")
      disabled = disabled
        or (success and node ~= nil and vim.tbl_contains({ "comment", "line_comment", "block_comment" }, node:type()))

      return not disabled
    end,

    completion = {
      list = { selection = { preselect = false, auto_insert = true } },
    },
  },
}
-- return {
--   {
--     "hrsh7th/nvim-cmp",
--     event = "InsertEnter",
--     dependencies = {
--       "hrsh7th/cmp-nvim-lsp",
--       "harsh7th/cmp-buffer",
--     },
--     config = function()
--       local cmp = require("cmp")
--       cmp.setup({
--         enabled = function()
--           local disabled = false
--           local context = require("cmp.config.context")
--           disabled = disabled or (vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt")
--           disabled = disabled or (vim.fn.reg_recording() ~= "")
--           disabled = disabled or (vim.fn.reg_executing() ~= "")
--           local row, column = unpack(vim.api.nvim_win_get_cursor(0))
--
--           local success, node = pcall(vim.treesitter.get_node, {
--
--             pos = { row - 1, math.max(0, column - 1) },
--
--             ignore_injections = false,
--           })
--
--           if success and node then
--             disabled = disabled or node:type():find("comment") -- Checks if the node type contains "comment"
--           end
--
--           return not disabled
--         end,
--       })
--     end,
--   },
-- }
