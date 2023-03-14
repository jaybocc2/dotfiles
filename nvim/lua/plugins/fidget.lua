local config = {}

local function setup()
  local fidget = jaylib.loadpkg("fidget")
  if fidget == nil then
    return
  end

  fidget.setup(config)
end

return { setup = setup }
