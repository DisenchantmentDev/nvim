local diagnostics_enabled = true

function _G.toggle_diagnostics()
  diagnostics_enabled = not diagnostics_enabled

  if diagnostics_enabled then
    vim.diagnostic.enable(true)
    vim.notify("LSP diagnostics enabled", vim.log.levels.INFO)
  else
    vim.diagnostic.enable(false)
    vim.notify("LSP diagnostics disabled", vim.log.levels.WARN)
  end
end
