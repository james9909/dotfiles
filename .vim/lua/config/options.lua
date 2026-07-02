local opt = vim.opt

if vim.fn.has("termguicolors") == 1 then
  opt.termguicolors = true
end

-- Neovim enables filetype detection, plugins, indent and syntax by default,
-- but plugins like gruvbox/rainbow still expect classic syntax highlighting.
vim.cmd("syntax enable")

opt.cursorline = true -- Highlight current line
opt.laststatus = 2 -- Always show statusline on last window
opt.showcmd = true -- Show commands as you type
opt.foldmethod = "marker"
opt.grepprg = "grep -nH $*" -- Set command for :grep

opt.expandtab = true -- Set tabs to spaces
opt.shiftwidth = 4 -- Tab size for auto indent
opt.shiftround = true -- Round indent to multiple of shiftwidth when using > or <
opt.tabstop = 4 -- A tab is 4 columns
opt.softtabstop = 4 -- A tab is 4 spaces

opt.autoindent = true
opt.number = true -- Enable line numbers
opt.wrap = true -- Wrap lines
opt.wildignore = "*.class,*.swp,*.pyc,*.jar,*.cmake,*.tar.*" -- Ignore compiled things
opt.mouse = "nvc" -- Enable the mouse for normal, visual, and command-line modes
opt.backspace = { "indent", "eol", "start" } -- Backspace is great
opt.hlsearch = true -- Highlight search term in text
opt.incsearch = true -- Show search matches as you type
opt.ignorecase = true -- Ignore case when searching
opt.smartcase = true -- Upper case letter in search makes it case-sensitive
opt.lazyredraw = true -- Don't redraw when executing macros
opt.colorcolumn = "200"
opt.completeopt = { "longest", "menuone" }
opt.backup = true -- Allow for a backup directory
opt.wrapscan = true -- Automatically wrap search when hitting bottom
opt.scrolloff = 2 -- Keep cursor 2 rows above the bottom when scrolling
opt.linebreak = true -- Break line on word
opt.timeoutlen = 500 -- Timeout for entering key combinations
opt.synmaxcol = 300 -- Limit syntax highlight parsing to first 300 columns
opt.hidden = true -- Hide buffers instead of closing them
opt.cinkeys:remove("0#") -- Prevent # from removing indents from a line
opt.indentkeys:remove("0#") -- Prevent # from removing indents from a line
opt.wildmenu = true -- Tab-like completion similar to zsh
opt.formatoptions:append("j") -- Remove comments when merging
opt.signcolumn = "yes" -- Always show the signcolumn to avoid shifting text
opt.shortmess:append("c") -- Don't pass messages to |ins-completion-menu|.
opt.updatetime = 300
opt.pyxversion = 3

-- Invisible characters
opt.list = true
opt.listchars = { tab = ">-" }

-- Press % on 'if' to jump to its corresponding 'else'
vim.cmd("runtime macros/matchit.vim")

-- If the backup/swap/undo directories do not exist, then make them
local home = vim.env.HOME
for _, dir in ipairs({ "/.vim/_backup", "/.vim/_swap", "/.vim/_undo" }) do
  local path = home .. dir
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

opt.directory = home .. "/.vim/_swap" -- Set swap directory
opt.backupdir = home .. "/.vim/_backup" -- This is the backup directory
opt.undofile = true -- Allows for undos after saving
opt.undodir = home .. "/.vim/_undo" -- This is the undo directory
opt.undolevels = 1000 -- Save a maximum of 1000 undos
opt.undoreload = 10000 -- Save undo history when reloading a file

opt.sessionoptions:remove("folds") -- Do not save folds

vim.g.clipbrdDefaultReg = "+" -- Default register for clipboard

-- File browsing
vim.g.netrw_liststyle = 3
vim.g.netrw_browse_split = 4
vim.g.netrw_altv = 1
