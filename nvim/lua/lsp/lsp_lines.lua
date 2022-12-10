local function setup()
  local lsplines = jaylib.loadpkg("lsp_lines")
  if lsplines == nil then
    return
  end

  lsplines.setup()
  vim.diagnostic.config({
    virtual_text = false -- disable virtual_text as it is redundant to lsp_lines
  })
end

return { setup = setup }
