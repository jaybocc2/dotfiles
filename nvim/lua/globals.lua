local function show_documentation()
  vim.notify("TODO: show_documentation unimplemented", "info")
end

local function setup()
  _G.show_documentation = show_documentation
end

return { setup = setup }
