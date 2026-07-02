local fn = require("config.functions")
local keyset = vim.keymap.set

-- NOTE: mapleader is set in init.lua before plugins load.

keyset("n", "i", fn.smart_insert_mode_enter, { expr = true })

-- coc.nvim ---------------------------------------------------------------
-- Use <Tab> to trigger completion and navigate the popup menu.
local coc_expr = { silent = true, noremap = true, expr = true, replace_keycodes = false }
keyset(
  "i",
  "<TAB>",
  'coc#pum#visible() ? coc#pum#next(1) : v:lua.check_back_space() ? "\\<Tab>" : coc#refresh()',
  coc_expr
)
keyset("i", "<S-TAB>", [[coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"]], coc_expr)

-- <CR> accepts the selected completion item or notifies coc to format.
keyset(
  "i",
  "<CR>",
  [[coc#pum#visible() ? coc#pum#confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"]],
  coc_expr
)

-- Use <c-space> to trigger completion.
keyset("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

-- Use K to show documentation in preview window.
keyset("n", "K", fn.show_documentation, { silent = true })

keyset("n", "gd", "<Plug>(coc-definition)", { silent = true })
keyset("n", "gy", "<Plug>(coc-type-definition)", { silent = true })
keyset("n", "gi", "<Plug>(coc-implementation)", { silent = true })
keyset("n", "gr", "<Plug>(coc-references)", { silent = true })

-- Clipboard --------------------------------------------------------------
-- Base copy/paste to/from the system clipboard.
keyset("x", "<C-c>", '"+y<CR>')
keyset("i", "<C-v>", [[<esc>:set paste<CR>"+]p`]:set nopaste<cr>a]])

-- Prefer xclip when available (matches the old has('nvim') block).
if vim.fn.has("clipboard") == 1 and vim.fn.executable("xclip") == 1 then
  local function clipboard_yank()
    vim.fn.system("xclip -i -selection clipboard", vim.fn.getreg('"'))
  end
  local function clipboard_paste()
    vim.fn.setreg('"', vim.fn.system("xclip -o -selection clipboard"))
  end
  keyset("x", "<C-c>", function()
    vim.cmd("normal! y")
    clipboard_yank()
  end, { silent = true })
  keyset("i", "<C-v>", function()
    clipboard_paste()
    vim.cmd("normal! p")
    vim.cmd("startinsert")
  end, { silent = true })
end

-- Remove search highlights
keyset("n", "<CR>", ":noh<CR><CR>")

-- Convenient leader maps
keyset("n", "<Leader>w", ":w<CR>")
keyset("n", "<Leader>W", ":w!<CR>")
-- Save with sudo
keyset("n", "<Leader>W!", ":w !sudo tee %>/dev/null<CR>", { silent = true })
keyset("n", "<Leader>q", ":q<CR>")
keyset("n", "<Leader>Q", ":q!<CR>")
keyset("n", "<Leader>i", function()
  fn.preserve("normal gg=G")
end)
keyset("n", "<Leader>n", fn.toggle_vexplorer, { silent = true })
keyset("n", "<Leader>h", ":split<CR>")
keyset("n", "<Leader>v", ":vsplit<CR>")

-- Tab Mappings
keyset("n", "<Leader>t", ":tabnew<CR>", { silent = true })

-- Better k and j movement
keyset("n", "k", "gk", { silent = true })
keyset("n", "j", "gj", { silent = true })

-- Remap jj to escape in insert mode.
keyset("i", "jj", "<Esc>")

-- Turn off Control-Space
keyset("i", "<Nul>", "<Space>", { remap = true })

-- Easier page up/down
keyset("n", "<C-k>", "3k")
keyset("n", "<C-j>", "3j")
keyset("x", "<C-k>", "3k")
keyset("x", "<C-j>", "3j")

-- Mundo
keyset("n", "<Leader>u", ":MundoToggle<CR>")

-- View highlight group under cursor
keyset("n", "<F3>", fn.show_highlight_group)

-- fzf
keyset("n", "<C-p>", ":FZF<CR>")
keyset("n", "<Leader>f", ":Rg<CR>")

-- Ale
keyset("n", "<Leader>c", ":ALELint<CR>")

keyset("n", "<Backspace>", "<NOP>")

-- Better x (don't clobber the unnamed register)
keyset({ "n", "x", "o" }, "x", '"_x')
keyset({ "n", "x", "o" }, "X", '"_X')

-- copilot
keyset("i", "<C-J>", 'copilot#Accept("")', { expr = true, silent = true, replace_keycodes = false })
keyset("i", "<C-H>", "copilot#Previous()", { expr = true, silent = true })
keyset("i", "<C-K>", "copilot#Next()", { expr = true, silent = true })

-- Neovim terminal --------------------------------------------------------
-- Preserve regular <Esc> in case we run neovim/vim inside the terminal.
keyset("t", "<Esc><Esc>", [[<C-\><C-n>]])

-- Use :terminal to execute a shell command
keyset("n", "<Leader>T", ":terminal<CR>")

-- Change cursor shape based on the current mode
vim.opt.guicursor =
  "n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor"

vim.opt.inccommand = "split"
