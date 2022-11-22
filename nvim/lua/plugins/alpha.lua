local icons = require("icons")

local header = {
" ▄▄▄▄▄▄▄▄▄▄▄  ▄         ▄  ▄▄▄▄▄▄▄▄▄▄▄       ▄▄▄▄▄▄▄▄▄▄▄     ▄▄▄▄▄▄▄▄▄▄▄      ",
"▐░░░░░░░░░░░▌▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░░░░░░░░░░░▌   ▐░░░░░░░░░░░▌     ",
" ▀▀▀▀█░█▀▀▀▀ ▐░▌       ▐░▌▐░█▀▀▀▀▀▀▀▀▀      ▐░█▀▀▀▀▀▀▀▀▀    ▐░█▀▀▀▀▀▀▀█░▌     ",
"     ▐░▌     ▐░▌       ▐░▌▐░▌               ▐░▌             ▐░▌       ▐░▌     ",
"     ▐░▌     ▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░█▄▄▄▄▄▄▄▄▄    ▐░▌       ▐░▌     ",
"     ▐░▌     ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░░░░░░░░░░░▌   ▐░▌       ▐░▌     ",
"     ▐░▌     ▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀       ▀▀▀▀▀▀▀▀▀█░▌   ▐░▌       ▐░▌     ",
"     ▐░▌     ▐░▌       ▐░▌▐░▌                         ▐░▌   ▐░▌       ▐░▌     ",
"     ▐░▌     ▐░▌       ▐░▌▐░█▄▄▄▄▄▄▄▄▄       ▄▄▄▄▄▄▄▄▄█░▌ ▄ ▐░█▄▄▄▄▄▄▄█░▌ ▄   ",
"     ▐░▌     ▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░░░░░░░░░░░▌▐░▌▐░░░░░░░░░░░▌▐░▌  ",
"      ▀       ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀▀▀▀▀▀▀▀▀▀▀  ▀  ▀▀▀▀▀▀▀▀▀▀▀  ▀   ",
"                                                                              ",
" ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄  ▄▄▄▄▄▄▄▄▄▄▄ ",
"▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌",
"▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀█░▌▐░█▀▀▀▀▀▀▀▀▀  ▀▀▀▀█░█▀▀▀▀ ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌",
"▐░▌       ▐░▌▐░▌       ▐░▌▐░▌               ▐░▌     ▐░▌          ▐░▌       ▐░▌",
"▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄█░▌▐░█▄▄▄▄▄▄▄▄▄      ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄ ▐░█▄▄▄▄▄▄▄█░▌",
"▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌▐░░░░░░░░░░░▌",
"▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀▀▀▀█░▌ ▀▀▀▀▀▀▀▀▀█░▌     ▐░▌     ▐░█▀▀▀▀▀▀▀▀▀ ▐░█▀▀▀▀█░█▀▀ ",
"▐░▌          ▐░▌       ▐░▌          ▐░▌     ▐░▌     ▐░▌          ▐░▌     ▐░▌  ",
"▐░▌          ▐░▌       ▐░▌ ▄▄▄▄▄▄▄▄▄█░▌     ▐░▌     ▐░█▄▄▄▄▄▄▄▄▄ ▐░▌      ▐░▌ ",
"▐░▌          ▐░▌       ▐░▌▐░░░░░░░░░░░▌     ▐░▌     ▐░░░░░░░░░░░▌▐░▌       ▐░▌",
" ▀            ▀         ▀  ▀▀▀▀▀▀▀▀▀▀▀       ▀       ▀▀▀▀▀▀▀▀▀▀▀  ▀         ▀ ",
"                                                                 By: JayBoCC2 ",
"                                                                              ",
}

local buttons = {
  {"e", icons.ui.NewFile .. " > New File", ":enew <CR>"},
  {"f", icons.ui.FindFile .. " > Find File", ":Telescope find_files<CR>"},
  {"r", icons.ui.Files .. " > Find File", ":Telescope find_files<CR>"},
  {"s", icons.ui.History .. " > Restore Session", ":Telescope session-lens<CR>"},
  {"p", icons.ui.Project .. " > Open Project", ":Telescope projects<CR>"},
  {"q", icons.ui.CloseAlt .. " > Exit", ":qa!<CR>"},
}

local function setup()
  local alpha = jaylib.loadpkg("alpha")
  if alpha == nil then return end

  local dashboard = require("alpha.themes.dashboard")
  dashboard.section.header.val = header
  dashboard.section.buttons.val = {}
  for _, v in ipairs(buttons) do
    table.insert(dashboard.section.buttons.val, dashboard.button(unpack(v)))
  end

  alpha.setup(dashboard.opts)
end

return { setup = setup }
