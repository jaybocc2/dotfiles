local schema = jaylib.loadpkg("schemastore")
if schema == nil then
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
