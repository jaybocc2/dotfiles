local config = {
}

local function setup()
  local octo = jaylib.loadpkg("octo")
  if octo == nil then
    return
  end

  octo.setup(config)
end

return { setup = setup }
