local status_ok, schema = pcall(require, "schemastore")
if not status_ok then
  vim.notify("failed to load schemastore in lsp/settings/jsonls.lua", "error")
  return
end

local opts = {
  init_options = {
    provideFormatter = false,
  },
  settings = {
    json = {
      schemas = schema.json.schemas(),
    },
  },
}

return opts
