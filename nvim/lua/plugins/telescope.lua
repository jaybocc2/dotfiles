local function setup()
  local telescope = jaylib.loadpkg("telescope")
  if telescope == nil then return end

  local icons = require("icons")

  telescope.setup({
    defaults = {
      prompt_prefix = icons.ui.Telescope .. " ",
      selection_caret = " ",
      path_display = { "smart" },
      file_ignore_patterns = {
        ".git/",
        "target/",
        "docs/",
        "vendor/*",
        "%.lock",
        "__pycache__/*",
        "%.sqlite3",
        "%.ipynb",
        "node_modules/*",
        -- '%.jpg',
        -- '%.jpeg',
        -- '%.png',
        "%.svg",
        "%.otf",
        "%.ttf",
        "%.webp",
        ".dart_tool/",
        ".github/",
        ".gradle/",
        ".idea/",
        ".settings/",
        ".vscode/",
        "__pycache__/",
        "build/",
        "env/",
        "gradle/",
        "node_modules/",
        "%.pdb",
        "%.dll",
        "%.class",
        "%.exe",
        "%.cache",
        "%.ico",
        "%.pdf",
        "%.dylib",
        "%.jar",
        "%.docx",
        "%.met",
        "smalljre_*/*",
        ".vale/",
        "%.burp",
        "%.mp4",
        "%.mkv",
        "%.rar",
        "%.zip",
        "%.7z",
        "%.tar",
        "%.bz2",
        "%.epub",
        "%.flac",
        "%.tar.gz",
      },
      pickers = {

        live_grep = {
          theme = "dropdown",
        },
        grep_string = {
          theme = "dropdown",
        },
        find_files = {
          theme = "dropdown",
          previewer = false,
        },
        buffers = {
          theme = "dropdown",
          previewer = false,
          initial_mode = "normal",
        },
        planets = {
          show_pluto = true,
          show_moon = true,
        },
        colorscheme = {
          -- enable_preview = true,
        },
        lsp_references = {
          theme = "dropdown",
          initial_mode = "normal",
        },
        lsp_definitions = {
          theme = "dropdown",
          initial_mode = "normal",
        },
        lsp_declarations = {
          theme = "dropdown",
          initial_mode = "normal",
        },
        lsp_implementations = {
          theme = "dropdown",
          initial_mode = "normal",
        },
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
      },
    },
  })
end

return { setup = setup }
