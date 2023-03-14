local icons = require("icons")

local function get_pickers(actions)
  local actions = jaylib.loadpkg("telescope.actions")
  if actions == nil then
    return {}
  end

  local default = {
    theme = "dropdown",
    initial_mode = "normal",
  }
  return {
    find_files = {
      theme = "dropdown",
      hidden = true,
      previewer = false,
    },
    live_grep = {
      --@usage don't include the filename in the search results
      only_sort_text = true,
      theme = "dropdown",
    },
    grep_string = {
      only_sort_text = true,
      theme = "dropdown",
    },
    buffers = vim.tbl_deep_extend("force", default, {
      previewer = false,
      mappings = {
        i = {
          ["<C-d>"] = actions.delete_buffer,
        },
        n = {
          ["dd"] = actions.delete_buffer,
        },
      },
    }),
    planets = {
      show_pluto = true,
      show_moon = true,
    },
    git_files = {
      theme = "dropdown",
      hidden = true,
      previewer = false,
      show_untracked = true,
    },
    lsp_references = vim.tbl_deep_extend("force", default, {}),
    lsp_definitions = vim.tbl_deep_extend("force", default, {}),
    lsp_declarations = vim.tbl_deep_extend("force", default, {}),
    lsp_implementations = vim.tbl_deep_extend("force", default, {}),
  }
end

local function get_mappings()
  local actions = jaylib.loadpkg("telescope.actions")
  if actions == nil then
    return {}
  end

  local mappings = {
    i = {
      ["<C-n>"] = actions.move_selection_next,
      ["<C-p>"] = actions.move_selection_previous,
      ["<C-c>"] = actions.close,
      ["<C-j>"] = actions.cycle_history_next,
      ["<C-k>"] = actions.cycle_history_prev,
      ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
      ["<CR>"] = actions.select_default,
    },
    n = {
      ["<C-n>"] = actions.move_selection_next,
      ["<C-p>"] = actions.move_selection_previous,
      ["<C-q>"] = actions.smart_send_to_qflist + actions.open_qflist,
    },
  }
  return mappings
end

local telescope_extensions = {
  "projects",
  "fzf",
  "notify",
  "session-lens",
}

local file_ignore_patterns = {
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
}

local defaults = {
  prompt_prefix = icons.ui.Telescope .. " ",
  selection_caret = icons.ui.Forward .. " ",
  entry_prefix = "  ",
  initial_mode = "insert",
  selection_strategy = "reset",
  sorting_strategy = "descending",
  layout_strategy = "horizontal",
  layout_config = {
    width = 0.75,
    preview_cutoff = 120,
    horizontal = {
      preview_width = function(_, cols, _)
        if cols < 120 then
          return math.floor(cols * 0.5)
        end
        return math.floor(cols * 0.6)
      end,
      mirror = false,
    },
    vertical = { mirror = false },
  },
  vimgrep_arguments = {
    "rg",
    "--color=never",
    "--no-heading",
    "--with-filename",
    "--line-number",
    "--column",
    "--smart-case",
    "--hidden",
    "--glob=!.git/",
  },
  ---@usage Mappings are fully customizable. Many familiar mapping patterns are setup as defaults.
  mappings = get_mappings(),
  pickers = get_pickers(),
  file_ignore_patterns = file_ignore_patterns,
  path_display = { "smart" },
  winblend = 0,
  border = {},
  borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
  color_devicons = true,
  set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
}

local pickers = get_pickers()

local extensions = {
  fzf = {
    fuzzy = true, -- false will only do exact matching
    override_generic_sorter = true, -- override the generic sorter
    override_file_sorter = true, -- override the file sorter
    case_mode = "smart_case", -- or "ignore_case" or "respect_case"
  },
}

local function setup()
  local telescope = jaylib.loadpkg("telescope")
  if telescope == nil then
    return
  end
  local previewers = jaylib.loadpkg("telescope.previewers")
  if previewers == nil then
    return
  end
  local sorters = jaylib.loadpkg("telescope.sorters")
  if sorters == nil then
    return
  end

  local icons = require("icons")

  telescope.setup(vim.tbl_extend("keep", {
    file_previewer = previewers.vim_buffer_cat.new,
    grep_previewer = previewers.vim_buffer_vimgrep.new,
    qflist_previewer = previewers.vim_buffer_qflist.new,
    file_sorter = sorters.get_fuzzy_file,
    generic_sorter = sorters.get_generic_fuzzy_sorter,
  }, {
    defaults = defaults,
    pickers = pickers,
    extensions = extensions,
  }))

  for _, ext in ipairs(telescope_extensions) do
    telescope.load_extension(ext)
  end
end

return { setup = setup }
