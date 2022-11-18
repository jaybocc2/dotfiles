local _M = {}

local function getcallerinfo(t)
  if not t then t = 3 end
  local callerinfo = debug.getinfo(t, 'nSl')
  -- local src = callerinfo.short_src:match("[^\\^/]*[.]lua$")
  local src = callerinfo.source
  local caller = src:match("(.*)[.]lua$")[1]
  local name = callerinfo.name
  return {
    src = src,
    caller = caller,
    line = callerinfo.currentline,
    name = name
  }
end

function _M.loadpkg(pkg_name)
  local status_ok, package = pcall(require, pkg_name)
  if not status_ok then
    local callerinfo = getcallerinfo()
    vim.notify("failed to load '" .. pkg_name .. "' in " .. callerinfo.src .. "::" .. callerinfo.name .. "::" .. callerinfo.line, "error")
    return
  end
  return package
end

function _M.check_backspace()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

jaylib = _M
