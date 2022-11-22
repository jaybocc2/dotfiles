local function setup()
  local package = jaylib.loadpkg("notify")
  if package == nil then return end

  ---vim notifications for notifying/alerting users
  ---@param msg string
  ---@param level string|nil
  ---@param opts table|nil
  local function notify(msg, level, opts)
    package.notify(msg, level, opts)
  end

  vim.notify = notify
end

return { setup = setup }
