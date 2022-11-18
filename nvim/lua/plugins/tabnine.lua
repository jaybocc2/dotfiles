local function setup()
  local package = jaylib.loadpkg("tabnine")
  if package == nil then return end

  package.setup({
    max_lines = 1000,
    max_num_results = 20,
    sort = true,
    run_on_every_keystroke = true,
    snippet_placeholder = "..",
    ignored_file_types = {
      -- none ignored by default; example:
      -- lua = true,
    },
  })
end

return { setup = setup }
