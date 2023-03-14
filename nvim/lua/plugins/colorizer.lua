local function setup()
  local colorizer = jaylib.loadpkg("colorizer")
  if colorizer == nil then
    return
  end

  colorizer.setup()
end

return { setup = setup }
