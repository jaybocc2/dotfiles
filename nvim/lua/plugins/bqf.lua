local config = {
}

local function setup()
  local bqf = jaylib.loadpkg("bqf")
  if bqf == nil then
    return
  end

  bqf.setup(config)
end

return { setup = setup }
