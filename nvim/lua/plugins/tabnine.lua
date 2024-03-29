local function disable_tabnine()
  -- can't use tabnine on rpi/rockpi as it is not supported https://github.com/codota/TabNine/issues/65
  local os = vim.loop.os_uname()
  if (os.machine == "aarch64" and os.sysname == "Linux") then
    return true
  end
  return false
end

local function setup()
  if disable_tabnine() then
    return
  end

  local package = jaylib.loadpkg("cmp_tabnine.config")
  if package == nil then
    return
  end

  package:setup({
    max_lines = 1000, -- default: 1000
    max_num_results = 20, -- default: 20
    sort = true, -- default: true
    run_on_every_keystroke = true, -- default: true
    snippet_placeholder = "..", -- default ".."
    ignored_file_types = {
      -- none ignored by default;
      -- language = bool,
      -- lua = true,
    },
    show_prediction_strength = true,
  })
end

return { setup = setup, disable_tabnine = disable_tabnine }
