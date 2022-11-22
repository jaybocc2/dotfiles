local _M = {}

---Get and return caller info for error debugging
---@param t int stack object to grab callerinfo for default: 3 (the func that called this func)
---@return { src = string, caller = string, line = integer, name = string }
local function getcallerinfo(t)
  if not t then t = 3 end
  local callerinfo = debug.getinfo(t, 'nSl')
  -- local src = callerinfo.short_src:match("[^\\^/]*[.]lua$")
  local src = callerinfo.source
  local caller = src:match("(.*)[.]lua$")[1]
  local name = "???"
  if callerinfo.name ~= nil then
	  name = callerinfo.name
  end
  return {
    src = src,
    caller = caller,
    line = callerinfo.currentline,
    name = name
  }
end

--- Safely load package and log error on failure
---@param pkg_name string the package to load
---@return table|nil the package or nil
function _M.loadpkg(pkg_name)
  local status_ok, package = pcall(require, pkg_name)
  if not status_ok then
    local callerinfo = getcallerinfo()
    vim.notify("failed to load '" .. pkg_name .. "' in " .. callerinfo.src .. "::" .. callerinfo.name .. "::" .. callerinfo.line, "error")
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

jaylib = _M
