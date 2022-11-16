local status_ok, schema = pcall(require, "schemastore")
if not status_ok then
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
