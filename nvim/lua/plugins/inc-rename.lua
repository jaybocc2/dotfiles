local config = {
  input_buffer_type = "dressing",
}

local function setup()
  local rename = jaylib.loadpkg("inc_rename")
  if rename == nil then
    return
  end

  rename.setup(config)
end

return { setup = setup }
