local fn = require("config.functions")
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- defaults ---------------------------------------------------------------
local defaults = augroup("defaults", { clear = true })

autocmd("BufReadPost", {
  group = defaults,
  callback = fn.follow_symlink,
})

autocmd("VimEnter", {
  group = defaults,
  callback = fn.airline_init,
})

-- Restore cursor location
autocmd("BufReadPost", {
  group = defaults,
  callback = function()
    local last = vim.fn.line("'\"")
    if last > 1 and last <= vim.fn.line("$") then
      vim.cmd('normal! g`"')
    end
  end,
})

-- Override ftplugins so comments aren't auto-continued with 'o'
autocmd("FileType", {
  group = defaults,
  callback = function()
    vim.opt_local.formatoptions:remove("o")
  end,
})

-- Automagically remove any trailing whitespace upon saving
autocmd("BufWrite", {
  group = defaults,
  callback = function()
    if not vim.bo.binary then
      fn.preserve([[silent! %s/\s\+$//ge]])
    end
  end,
})

-- whitespace -------------------------------------------------------------
local whitespace = augroup("whitespace", { clear = true })

-- Derive the ExtraWhitespace highlight from the gruvbox-material palette.
local ok, _ = pcall(function()
  local config = vim.fn["gruvbox_material#get_configuration"]()
  local palette = vim.fn["gruvbox_material#get_palette"](
    config.background,
    config.foreground,
    config.colors_override
  )
  vim.cmd(string.format(
    "highlight ExtraWhitespace ctermbg=%s guibg=%s",
    palette.bg_red[2],
    palette.bg_red[1]
  ))
end)
if not ok then
  vim.cmd("highlight ExtraWhitespace ctermbg=red guibg=red")
end

autocmd("BufWinEnter", {
  group = whitespace,
  callback = function()
    vim.cmd([[match ExtraWhitespace /\s\+$/]])
  end,
})
-- Match whitespace except when typing
autocmd("InsertEnter", {
  group = whitespace,
  callback = function()
    vim.cmd([[match ErrorMsg /\s\+\%#\@<!$/]])
  end,
})
autocmd("InsertLeave", {
  group = whitespace,
  callback = function()
    vim.cmd([[match ErrorMsg /\s\+$/]])
  end,
})
autocmd("BufWinLeave", {
  group = whitespace,
  callback = function()
    vim.fn.clearmatches()
  end,
})

-- filetype-specific ------------------------------------------------------
local ft = augroup("filetype_settings", { clear = true })

autocmd("FileType", {
  group = ft,
  pattern = "python",
  callback = function()
    vim.opt_local.foldenable = true
    vim.opt_local.foldmethod = "syntax"
  end,
})

autocmd("FileType", {
  group = ft,
  pattern = "yaml",
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.expandtab = true
  end,
})

autocmd("FileType", {
  group = ft,
  pattern = "go",
  callback = function()
    vim.opt_local.listchars:append({ tab = "  " }) -- Trailing space
  end,
})

-- Detect if file contents have changed when re-entering
autocmd("FocusGained", {
  group = defaults,
  callback = function()
    vim.cmd("checktime")
  end,
})

-- user commands ----------------------------------------------------------
vim.api.nvim_create_user_command("FollowSymlink", fn.follow_symlink, {})

vim.api.nvim_create_user_command("GGrep", function(cmd)
  local dir = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
  vim.fn["fzf#vim#grep"](
    "git grep --line-number -- " .. vim.fn.shellescape(cmd.args),
    0,
    vim.fn["fzf#vim#with_preview"]({ dir = dir }),
    cmd.bang
  )
end, { bang = true, nargs = "*" })
