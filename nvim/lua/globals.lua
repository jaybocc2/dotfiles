
local function show_documentation()
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
