local function setup()
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
  })
end

return { setup = setup }
