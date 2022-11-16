M = {}

M.server_capabilities = function()
  local active_clients = vim.lsp.get_active_clients()
  local active_client_map = {}

  for index, value in ipairs(active_clients) do
    active_client_map[value.name] = index
  end

  vim.ui.select(vim.tbl_keys(active_client_map), {
    prompt = "Seclect client:",
    format_item = function(item)
      return "capabilities for: " .. item
    end,
  }, function(choice)
    print(
      vim.inspect(vim.lsp.get_active_clients()[active_client_map[choice]].server_capabilities.executeCommandProvider)
    )
    vim.pretty_print(vim.lsp.get_active_clients()[active_client_map[choice]].server_capabilities)
  end)
end

M.setup = function()
  local status_ok, _ = pcall(require, "lspconfig")
  if not status_ok then
    return
  end
  -- require "user.lsp.lsp-signature"
  -- -- require "user.lsp.lsp-installer"
  -- require("user.lsp.mason")
  -- require("user.lsp.handlers").setup()
  -- require "user.lsp.null-ls"
  require("lsp.signature").setup()
  require("lsp.mason").setup()
  require("lsp.handlers").setup()
  require("lsp.null-ls").setup()
  local status_ok2, lsp_lines = pcall(require, "lsp_lines")
  if not status_ok2 then
    return
  end
  lsp_lines.setup()
end

return M
