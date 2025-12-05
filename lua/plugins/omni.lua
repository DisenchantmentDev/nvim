if true then
  return {}
end

return {
  { "getomni/neovim" },

  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "omni",
    },
  },
}
