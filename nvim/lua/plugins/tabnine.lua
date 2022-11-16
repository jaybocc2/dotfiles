local function setup()
  local package_name = "tabnine"
  local status_ok, package = pcall(require, package_name)
  if not status_ok then
    return
  end
end

return { setup = setup }
