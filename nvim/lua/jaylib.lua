local _M = {}

---Get and return caller info for error debugging
---@param t integer|nil stack object to grab callerinfo for default: 3 (the func that called this func)
---@return { src: string, src_path: string, caller: string, line: integer, name: string }
function _M.getcallerinfo(t)
  if not t then t = 3 end
  local callerinfo = debug.getinfo(t, 'nSl')
  local src_path, src =  callerinfo.source:match(".*[/][.]config[/](.*[/])(.*[.]lua)$")
  local caller = src:match("(.*)[.]lua$")
  local name = "???"
  if callerinfo.name ~= nil then
	  name = callerinfo.name
  end
  return {
    src = src,
    src_path = src_path,
    caller = caller,
    line = callerinfo.currentline,
    name = name
  }
end

---vim notifications for notifying/alerting users w/ debug hints
---@param msg string
---@param level string|nil
---@param opts table|nil
function _M.notify(msg, level, opts)
  local callerinfo = _M.getcallerinfo()
  -- if loadpkg is calling us we need to get next caller in the stack
  if callerinfo.name == "loadpkg" then
    callerinfo = _M.getcallerinfo(4)
  end
  vim.notify(callerinfo.src_path ..  callerinfo.src .. "::" .. callerinfo.line .. "::" .. callerinfo.name .. "() - " .. msg, level, opts)
end

--- Safely load package and log error on failure
---@param pkg_name string the package to load
---@return table|nil the package or nil
function _M.loadpkg(pkg_name)
  local status_ok, package = pcall(require, pkg_name)
  if not status_ok then
    _M.notify("failed to load pkg - missing or not installed - " .. pkg_name, "warn")
    return nil
  end
  return package
end

function _M.check_backspace()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

---Get the full path to cache directory
---@return string
function _M.get_cache_dir()
  local cache_dir = os.getenv "NEOVIM_CACHE_DIR"
  if not cache_dir then
    return vim.fn.stdpath("cache")
  end
  return cache_dir
end

--- Clean autocommand in a group if it exists
--- This is safer than trying to delete the augroup itself
---@param name string the augroup name
function _M.clear_augroup(name)
  -- defer the function in case the autocommand is still in-use
  vim.schedule(function()
    pcall(function()
      vim.api.nvim_clear_autocmds { group = name }
    end)
  end)
end

-- make jaylib a global library for neovim
_G.jaylib = _M
