-- Leader must be set before lazy loads so plugin mappings pick it up.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("config.options")

-- Bootstrap lazy.nvim ------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  -- Old plugins were kept in ~/.vim/bundle via vim-plug; lazy uses its own dir
  -- under stdpath("data")/lazy, so nothing there is reused.
  change_detection = { notify = false },
})

-- These run after plugins load so highlight/statusline hooks can see them.
require("config.keymaps")
require("config.autocmds")
