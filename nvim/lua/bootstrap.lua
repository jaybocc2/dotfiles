local echohl = vim.schedule_wrap(function(msg, hl)
  local emsg = vim.fn.escape(msg, '"')
  vim.cmd("echohl " .. hl .. ' | echom "' .. emsg .. '" | echohl None')
end)

local info = function(msg)
  echohl(msg, "None")
end
local err = function(msg)
  echohl(msg, "ErrorMsg")
end

local function init(packages)
  -- require('packer').startup(packages)
  local status_ok, packer = pcall(require, "packer")
  if not status_ok then
    info("[packer]: Not found...")
    return
  end

  packer.init({
    snapshot_path = vim.fn.stdpath("config") .. "/snapshots",
    max_jobs = 50,
    display = {
      open_fn = function()
        return require("packer.util").float({ border = "rounded" })
      end,
      prompt_border = "rounded",
    },
  })
  packer.startup(function(use)
    for i, pkg in ipairs(packages) do
      use(pkg)
    end
  end)
  packer.sync()
end

local setup = function(packages)
  local bailout = false
  -- Bootstrap `packer` installation to manage packages
  local packer = {
    path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim",
    url = "https://github.com/wbthomason/packer.nvim",
  }

  if vim.fn.executable("git") ~= 1 then
    err("[packer] Bootstrap failed, git not installed")
    return
  end

  if vim.fn.empty(vim.fn.glob(packer.path)) > 0 then
    info("[packer]: Installing...")

    local handle
    handle = vim.loop.spawn(
      "git",
      {
        args = {
          "clone",
          packer.url,
          packer.path,
        },
      },
      vim.schedule_wrap(function(code, _)
        -- Wrapper to load packer based on the success of the above `git` operation
        handle:close()
        if code == 0 then -- if no error load packer plugin
          info("[packer]: Loading packer for first time")
          vim.cmd("packadd packer.nvim")
        else -- if error set bailout
          err("[packer]: Failed setup")
          bailout = true
        end
      end)
    )
  end

  if not bailout then
    init(packages)
  end
end

return { setup = setup }
