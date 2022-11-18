local function setup()
  local package = jaylib.loadpkg("notify")
  if package == nil then return end

  vim.notify = package
end

return { setup = setup }
