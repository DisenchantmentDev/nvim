-- Plugins (managed with |vim.pack|):
-- Dired.nvim
-- Bufferline
-- Lualine
-- clangd_extensions
-- compile-mode
-- d-clipboard (deferred-clipboard.nvim)
-- doing
-- multiple-cursors
-- nord
-- nvim-lspconfig
-- mason-lspconfig.nvim (bridge Mason installs → vim.lsp.enable)
-- blink.cmp
-- telescope
-- vimscape
-- flash.nvim
-- plenary (dependency)
-- nui (dependency for dired)
-- nvim-web-devicons (dependency for bufferline)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- From init.lua / lua/config/options.lua: disable arrow keys for movement
for _, mode in ipairs({ "n", "i", "v" }) do
  vim.keymap.set(mode, "<Up>", "<Nop>", { noremap = true, silent = true })
  vim.keymap.set(mode, "<Down>", "<Nop>", { noremap = true, silent = true })
  vim.keymap.set(mode, "<Left>", "<Nop>", { noremap = true, silent = true })
  vim.keymap.set(mode, "<Right>", "<Nop>", { noremap = true, silent = true })
end

vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.softtabstop = 4

vim.opt.number = true
vim.opt.relativenumber = true

vim.keymap.set("n", "<leader>ms", "<cmd>LspStart<CR>", { desc = "Start LSP" })
vim.keymap.set("n", "<leader>mx", "<cmd>LspStop<CR>", { desc = "Stop LSP" })
vim.keymap.set("n", "<leader>t", "<cmd>Dired<CR>", { desc = "Dired" })
vim.keymap.set("n", "<leader>z", ":Compile ", { desc = "Compile Mode", noremap = false })

-- compile-mode (from lua/plugins/compile-mode.lua) — set before plugins load
vim.g.compile_mode = {
  input_word_completion = true,
}

local gh = function(repo)
  return "https://github.com/" .. repo
end

vim.pack.add({
  -- dependencies first
  gh("nvim-lua/plenary.nvim"),
  gh("MunifTanjim/nui.nvim"),
  gh("nvim-tree/nvim-web-devicons"),

  gh("X3eRo0/dired.nvim"),
  gh("akinsho/bufferline.nvim"),
  gh("nvim-lualine/lualine.nvim"),
  gh("p00f/clangd_extensions.nvim"),
  { src = gh("ej-shafran/compile-mode.nvim"), version = vim.version.range("5") },
  gh("EtiamNullam/deferred-clipboard.nvim"),
  gh("Hashino/doing.nvim"),
  gh("brenton-leighton/multiple-cursors.nvim"),
  gh("shaunsingh/nord.nvim"),
  -- Pin 1.x so the checkout matches a release tag; prebuilt fuzzy lib downloads work. On
  -- untagged checkouts (e.g. main), use fuzzy.prebuilt_binaries.force_version in blink.setup.
  { src = gh("saghen/blink.cmp"), version = vim.version.range("1") },
  gh("neovim/nvim-lspconfig"),
  gh("mason-org/mason-lspconfig.nvim"),
  { src = gh("nvim-telescope/telescope.nvim"), version = "v0.1.9" },
  -- Lazy had `version = "*"`; vim.pack needs a branch/tag/range (use latest semver)
  gh("folke/flash.nvim"),
  gh("mason-org/mason.nvim"),
}, { load = true })

-- Mason early: prepends Mason bin to PATH before any LSP may start.
require("mason").setup({})
-- Auto `vim.lsp.enable()` for Mason-installed servers (needs nvim 0.11 + nvim-lspconfig).
-- Exclude clangd: configured manually below with blink.cmp capabilities + clangd_extensions.
require("mason-lspconfig").setup({
  automatic_enable = {
    exclude = { "clangd" },
  },
})

-- Dired (from lua/plugins/dired.lua)
require("dired").setup({
  path_separator = "/",
  override_cwd = false,
  show_hidden = true,
  show_icons = true,
  sort_order = "name",
})

-- Bufferline (from lua/plugins/bufferline.lua)
require("bufferline").setup({})
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>")
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>")
vim.keymap.set("n", "<leader>bn", "<cmd>BufferLineCycleNext<CR>")
vim.keymap.set("n", "<leader>bp", "<cmd>BufferLineCyclePrev<CR>")

-- doing.nvim (from lua/plugins/doing.lua)
require("doing").setup({
  winbar = {
    enabled = false,
  },
})
vim.keymap.set("n", "<leader>da", function()
  require("doing").add()
end, { desc = "[D]oing: [A]dd" })
vim.keymap.set("n", "<leader>dn", function()
  require("doing").done()
end, { desc = "[D]oing: Do[n]e" })
vim.keymap.set("n", "<leader>de", function()
  require("doing").edit()
end, { desc = "[D]oing: [E]dit" })

-- Lualine + doing status (from lua/plugins/lualine.lua)
require("lualine").setup({
  sections = {
    lualine_c = { require("doing").status },
  },
})

-- clangd_extensions (from lua/plugins/clangd_extensions.lua)
require("clangd_extensions").setup({
  inlay_hints = {
    inline = true,
  },
})

-- blink.cmp: completion; get_lsp_capabilities() merges with nvim-lspconfig / vim.lsp.config
require("blink.cmp").setup({
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

  -- Fuzzy matcher: prebuilts are tied to a git tag. Without this, tracking `main` has no
  -- tag, so nothing is downloaded — set force_version so curl fetches a release build.
  -- Alternative: pure Lua (no Rust) — fuzzy = { implementation = "lua" }.
  -- Build locally: `:BlinkCmp build` (needs Rust/cargo), or `cargo build --release` in the
  -- plugin directory (see :BlinkCmp build-log on failure).
  fuzzy = {
    prebuilt_binaries = {
      force_version = "v*",
    },
  },
})

-- nvim-lspconfig / clangd: merged from lua/plugins/nvim-lspconfig.lua (LazyVim-specific
-- setup{} hook replaced with vim.lsp.config + enable)
vim.lsp.config("clangd", {
  cmd = {
    "clangd",
    "--background-index",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--completion-style=detailed",
    "--function-arg-placeholders",
    "--fallback-style=llvm",
  },
  capabilities = require("blink.cmp").get_lsp_capabilities({
    textDocument = {
      completion = {
        editsNearCursor = true,
      },
    },
    offsetEncoding = { "utf-16" },
  }),
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
    clangdFileStatus = true,
  },
  root_markers = {
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    "configure.in",
    "config.h.in",
    "meson.build",
    "meson_options.txt",
    "build.ninja",
    ".git",
  },
})
vim.lsp.enable("clangd")

vim.keymap.set("n", "<leader>ch", "<cmd>LspClangdSwitchSourceHeader<cr>", { desc = "Switch Source/Header (C/C++)" })

-- deferred-clipboard (from lua/plugins/d-clipboard.lua)
require("deferred-clipboard").setup({
  lazy = true,
  fallback = "unnamedplus",
})

-- multiple-cursors (from lua/plugins/multi-cursor.lua)
require("multiple-cursors").setup({})
vim.keymap.set({ "n", "x" }, "<C-j>", "<Cmd>MultipleCursorsAddDown<CR>", { desc = "Add cursor and move down" })
vim.keymap.set({ "n", "x" }, "<C-k>", "<Cmd>MultipleCursorsAddUp<CR>", { desc = "Add cursor and move up" })
vim.keymap.set({ "n", "i", "x" }, "<C-Up>", "<Cmd>MultipleCursorsAddUp<CR>", { desc = "Add cursor and move up" })
vim.keymap.set({ "n", "i", "x" }, "<C-Down>", "<Cmd>MultipleCursorsAddDown<CR>", { desc = "Add cursor and move down" })
vim.keymap.set(
  { "n", "i" },
  "<C-LeftMouse>",
  "<Cmd>MultipleCursorsMouseAddDelete<CR>",
  { desc = "Add or remove cursor" }
)
vim.keymap.set(
  "x",
  "<Leader>m",
  "<Cmd>MultipleCursorsAddVisualArea<CR>",
  { desc = "Add cursors to the lines of the visual area" }
)
vim.keymap.set({ "n", "x" }, "<Leader>a", "<Cmd>MultipleCursorsAddMatches<CR>", { desc = "Add cursors to cword" })
vim.keymap.set(
  { "n", "x" },
  "<Leader>A",
  "<Cmd>MultipleCursorsAddMatchesV<CR>",
  { desc = "Add cursors to cword in previous area" }
)
vim.keymap.set(
  { "n", "x" },
  "<Leader>d",
  "<Cmd>MultipleCursorsAddJumpNextMatch<CR>",
  { desc = "Add cursor and jump to next cword" }
)
vim.keymap.set({ "n", "x" }, "<Leader>D", "<Cmd>MultipleCursorsJumpNextMatch<CR>", { desc = "Jump to next cword" })
vim.keymap.set({ "n", "x" }, "<Leader>l", "<Cmd>MultipleCursorsLock<CR>", { desc = "Lock virtual cursors" })

-- Telescope (from lua/plugins/telescope.lua; no extra opts in your repo)
require("telescope").setup({})

do
  local tb = require("telescope.builtin")
  vim.keymap.set("n", "<leader><leader>", tb.find_files, { desc = "Telescope find files" })
  vim.keymap.set("n", "<leader>sg", tb.live_grep, { desc = "Telescope live grep" })
  vim.keymap.set("n", "<leader>sb", tb.buffers, { desc = "Telescope buffers" })
  vim.keymap.set("n", "<leader>sh", tb.help_tags, { desc = "Telescope help" })
  vim.keymap.set("n", "<leader>sk", tb.keymaps, { desc = "Telescope keymaps" })
  vim.keymap.set("n", "<leader>ss", tb.builtin, { desc = "Telescope pickers" })
  vim.keymap.set("n", "<leader>fr", tb.oldfiles, { desc = "Telescope recent files" })
end

-- flash.nvim: listed in your plugin set; no lua/plugins/flash.lua — use plugin defaults
require("flash").setup({})
vim.keymap.set({"n", "x", "o"}, "s", function() require("flash").jump() end, {desc = "Flash" })
vim.keymap.set({"o"}, "r", function() require("flash").remote() end, {desc = "Remote Flash" })

-- Nord (from lua/plugins/nord.lua; LazyVim colorscheme opt replaced with direct colorscheme)
vim.cmd.colorscheme("nord")
