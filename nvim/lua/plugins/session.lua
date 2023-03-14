local config = {
  auto_session_suppress_dirs = {
    "~/",
    "~/scratch",
    "~/Downloads/",
    "~/Documents",
    "~/repos",
  }
}

local function setup()
  local session = jaylib.loadpkg("auto-session")
  if session == nil then
    return
  end

  session.setup(config)

  -- repo's recommended sessionoptions
  vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
end

return { setup = setup }
