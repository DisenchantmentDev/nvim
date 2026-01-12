-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- '
--

--vim.keymap.set("n", "<leader>mt", function()
--local bufnr = vim.api.nvim_get_current_buf()
--local enabled = vim.diagnostic.is_enabled(bufnr)
--
--vim.diagnostic.enable(not enabled, { bufnr = bufnr })
--
--vim.notify(
--  enabled and "Diagnostics disabled (buffer)" or "Diagnostics enabled (buffer)",
--           vim.log.levels.INFO
--)
--end, { desc = "Toggle diagnostics (buffer)" })

vim.keymap.set("n", "<leader>ms", "<cmd>LspStart<CR>", { desc = "Start LSP" })
vim.keymap.set("n", "<leader>mx", "<cmd>LspStop<CR>", { desc = "Stop LSP" })

vim.keymap.set("n", "<Up>", "", { noremap = true, silent = true })
vim.keymap.set("n", "<Down>", "", { noremap = true, silent = true })
vim.keymap.set("n", "<Left>", "", { noremap = true, silent = true })
vim.keymap.set("n", "<Right>", "", { noremap = true, silent = true })

vim.api.nvim_set_keymap("i", "<Up>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<Down>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<Left>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<Right>", "<Nop>", { noremap = true, silent = true })

vim.api.nvim_set_keymap("v", "<Up>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<Down>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<Left>", "<Nop>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<Right>", "<Nop>", { noremap = true, silent = true })

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.softtabstop = 4

vim.g.lazyvim_rust_diagnostics = "rust-analyzer"

vim.g.VM_maps = {
  ["Select Cursor Down"] = "<leader>]",
  ["Select Cursor Up"] = "<leader>[",
}
