local function setup()
  local package_name = "impatient"
  local status_ok, package = pcall(require, package_name)
  if not status_ok then
    return
  end

  package.enable_profile()
end

return { setup = setup }
