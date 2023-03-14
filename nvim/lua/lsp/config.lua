local _M = {}

local icons = require("icons")

_M.diagnostics = {
  signs = {
    active = true,
    values = {
      { name = "DiagnosticSignError", text = icons.diagnostics.Error },
      { name = "DiagnosticSignWarn", text = icons.diagnostics.Warning },
      { name = "DiagnosticSignHint", text = icons.diagnostics.Hint },
      { name = "DiagnosticSignInfo", text = icons.diagnostics.Info },
    },
  },
  virtual_text = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
    format = function(d)
      local code = d.code or (d.user_data and d.user_data.lsp.code)
      if code then
        return string.format("%s [%s]", d.message, code):gsub("1. ", "")
      end
      return d.message
    end,
  },
}

_M.float = {
  focusable = true,
  style = "minimal",
  border = "rounded",
}

_M.buffer_mappings = {
  normal_mode = {
    ["K"] = { vim.lsp.buf.hover, "Show hover" },
    ["gd"] = { vim.lsp.buf.definition, "Goto Definition" },
    ["gD"] = { vim.lsp.buf.declaration, "Goto declaration" },
    ["gr"] = { vim.lsp.buf.references, "Goto references" },
    ["gI"] = { vim.lsp.buf.implementation, "Goto Implementation" },
    ["gs"] = { vim.lsp.buf.signature_help, "show signature help" },
    ["gl"] = {
      function()
        local config = _M.diagnostics.float
        config.scope = "line"
        vim.diagnostic.open_float({ bufnr = 0, unpack(config) })
      end,
      "Show line diagnostics",
    },
  },
  insert_mode = {},
  visual_mode = {},
}

_M.buffer_options = {
  --- enable completion triggered by <c-x><c-o>
  omnifunc = "v:lua.vim.lsp.omnifunc",
  --- use gq for formatting
  formatexpr = "v:lua.vim.lsp.formatexpr(#{timeout_ms:500})",
}

return _M
