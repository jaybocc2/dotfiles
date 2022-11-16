function _G.check_back_space()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function _G.show_documentation()
  local ft = vim.bo.filetype
  local cword = vim.fn.expand("<cword>")
  if vim.fn.index({ "vim", "help" }, ft) then
    vim.fn.execute("help " .. cword)
  elseif vim.fn["coc#rpc#ready"]() then
    vim.fn.call("CocActionAsync", { "doHover" })
  else
    vim.fn.execute(vim.o.keywordprg .. " " .. cword)
  end
end

local function setup()
  return
end

return { setup = setup }
