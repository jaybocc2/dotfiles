local config = {
  cmp = {
    true,
    method = "getCompletionsCycling",
  },
  panel = {
    enabled = true,
  },
  ft_disable = { "markdown" },
  server_opts_overrides = {
    settings = {
      advanced = {
        inlineSuggestCount = 3,
      }
    }
  }
}

local function setup()
  local copilot = jaylib.loadpkg("copilot")
  if copilot == nil then
    return
  end

  copilot.setup(config)
end

return { setup = setup }
