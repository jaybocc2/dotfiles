local function setup()
  local package = jaylib.loadpkg("impatient")
  if package == nil then return end

  package.enable_profile()
end

return { setup = setup }
