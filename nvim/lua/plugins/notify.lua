local function setup()
  local package_name = "notify"
  local status_ok, package = pcall(require, package_name)
  if not status_ok then
    return
  end

  vim.notify = package
end

return { setup = setup }
