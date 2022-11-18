local function setup()
  local package = jaylib.loadpkg("nvim-tree")
  if package == nil then return end
end

return { setup = setup }
