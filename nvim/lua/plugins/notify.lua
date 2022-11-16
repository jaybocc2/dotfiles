local function setup()
  local package_name = "notify"
  local status_ok, package = pcall(require, package_name)
  if not status_ok then
    vim.notify("failed to load notify in plugins/notify.lua", "error")
    return
  end

  vim.notify = package
end

return { setup = setup }
