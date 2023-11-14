"{{{Plugins
try
    call plug#begin('~/.vim/bundle')

    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'simnalamburt/vim-mundo', { 'on': 'GundoToggle' }
    Plug 'Valloric/MatchTagAlways', { 'for': 'html' }
    Plug 'Yggdroot/indentLine'
    Plug 'alvan/vim-closetag'
    Plug 'alx741/vim-hindent', { 'for': 'haskell' }
    Plug 'bling/vim-airline'
    Plug 'gioele/vim-autoswap'
    Plug 'github/copilot.vim'
    Plug 'fatih/vim-go', { 'for': 'go' }
    Plug 'HerringtonDarkholme/yats.vim', { 'for': ['typescript', 'javascript', 'typescriptreact', 'javascriptreact'] }
    Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }
    Plug 'jiangmiao/auto-pairs'
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'Konfekt/FastFold'
    Plug 'luochen1990/rainbow'
    Plug 'machakann/vim-sandwich'
    Plug 'MaxMEllon/vim-jsx-pretty', { 'for': ['typescript', 'javascript', 'typescriptreact', 'javascriptreact'] }
    Plug 'mhinz/vim-signify'
    Plug 'neovimhaskell/haskell-vim', { 'for': 'haskell' }
    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'stephpy/vim-yaml', { 'for': 'yaml' }
    Plug 'rust-lang/rust.vim', { 'for': 'rust' }
    Plug 'sainnhe/gruvbox-material'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-sleuth'
    Plug 'w0rp/ale'
    Plug 'plasticboy/vim-markdown'

    if executable('rg')
        let $FZF_DEFAULT_COMMAND = "rg
              \ --files
              \ --no-ignore-vcs
              \ --hidden
              \ --ignore-file ~/.gitignore_global
              \ -g '!{node_modules,.git,.cache}'
              \ --follow"
    endif

    let g:fzf_preview_window = ['right:50%', 'ctrl-/']
    let g:fzf_buffers_jump = 1

    " Airline
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#hunks#enabled = 1
    let g:airline#extensions#hunks#hunk_symbols = ['+', 'Δ', '-']
    let g:airline#extensions#hunks#non_zero_only = 1
    let g:airline#extensions#virtualenv#enabled = 1

    " Signify
    let g:signify_vcs_list = ['git']
    let g:signify_realtime = 0
    let g:signify_cursorhold_insert = 0

    let g:signify_sign_add = '+'
    let g:signify_sign_change = 'Δ'
    let g:signify_sign_delete = '-'
    let g:signify_sign_delete_first_line = '^'
    let g:signify_sign_changedelete = 'Δ-'

    " Mundo
    let g:mundo_width = 30
    let g:mundo_preview_height = 15
    let g:mundo_preview_bottom = 1

    " DelimitMate
    let g:delimitMate_expand_inside_quotes = 1
    let g:delimitMate_expand_cr = 1
    let g:delimitMate_nesting_quotes = ['"', '`', '"']

    " MatchTagAlways
    let g:mta_use_match_paren_group = 1

    " indentLine
    let g:indentLine_char = '¦'
    let g:indentLine_color_term = 239

    " Disable errors for the fmt command
    let g:go_fmt_fail_silently = 1
    let g:go_code_completion_enabled = 0
    let g:go_fmt_autosave = 0
    let g:go_imports_autosave = 0
    let g:go_fmt_command = "goimports"
    let g:go_def_mapping_enabled = 0
    let g:go_gopls_enabled = "false"
    let g:go_doc_keywordprg_enabled = 0

    " Allow JSX syntax highlighting in .js files
    let g:jsx_ext_required = 0

    " Run :RustFmt when saving a buffer
    let g:rustfmt_autosave = 1

    " Ale
    let g:ale_lint_on_text_changed = "insert" " Run ale only in insert mode
    let g:ale_lint_on_insert_leave = 1 " Run ale when exiting insert mode
    let g:ale_type_map = {'flake8': {'ES': 'WS', 'E': 'W'}} " Map style errors to warnings
    let g:ale_python_flake8_args = '--ignore=E302,E305,E501'
    let g:ale_lint_delay = 500 " Lint after 500 milliseconds

    let g:ale_linters = {'go': ['revive'], 'rust': [], 'python': []}

    let g:rainbow_active = 1
    let g:rainbow_conf = {
        \   'ctermfgs': ['white', 'lightgreen', 'lightblue', 'lightmagenta'],
        \   'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/'],
      \}

    let g:gruvbox_material_background = 'medium'

    let g:AutoPairsMultilineClose = 0

    " Markdown
    let g:vim_markdown_conceal = 0
    let g:vim_markdown_conceal_code_blocks = 0
    let g:vim_markdown_folding_disabled = 1

    let g:copilot_assume_mapped = v:true
    let g:copilot_no_tab_map = 1

    call plug#end()

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"rust", "javascript", "go", "bash", "toml", "yaml", "html", "typescript" },
  highlight = {
    enable = true,
  },
}
EOF
catch /:E117:/
    echom "Vim-Plug is not installed!"
endtry
"}}}
"{{{Misc Settings
if has('termguicolors')
  set termguicolors
endif
filetype off " Clear filetype
filetype plugin indent on " Enable filetype-specific indentation and plugins
syntax on " Enable syntax highlighting
set background=dark
colorscheme gruvbox-material " Gruvbox runs 'syntax reset' anyways
set cursorline " Highlight current line
set laststatus=2 " Always show statusline on last window
set showcmd " Show commands as you type
set t_Co=256 " Enable 256 color
set foldmethod=marker
set grepprg=grep\ -nH\ $* " Set command for :grep

set expandtab " Set tabs to spaces
set shiftwidth=4 " Tab size for auto indent
set shiftround " Round indent to multiple of shiftwidth when using > or <
set tabstop=4 " A tab is 4 columns
set softtabstop=4 " A tab is 4 spaces

set autoindent
set number " Enable line numbers
set wrap " Wrap lines
set wildignore=*.class,*.swp,*.pyc,*.jar,*.cmake,*.tar.* " Ignore compiled things
set mouse=nvc " Enable the mouse for normal, visual, and command-line modes
set backspace=indent,eol,start " Backspace is great
set hlsearch " Highlight search term in text
set incsearch " Show search matches as you type
set ignorecase "Ignore case when searching
set smartcase " When using an upper case letter in search, search becomes case-sensitive
set lazyredraw " Don't redraw when executing macros
set colorcolumn=200
set completeopt=longest,menuone
set pastetoggle=<F2> " Toggle paste mode
set backup " Allow for a backup directory
set wrapscan " Automatically wrap search when hitting bottom
set scrolloff=2 " Keep cursor 2 rows above the bottom when scrolling
set linebreak " Break line on word
set timeoutlen=500 " Timeout for entering key combinations
set synmaxcol=300 " Limit syntax highlight parsing to first 300 columns
set hidden " Hide buffers instead of closing them
set cinkeys-=0# " Prevent # from removing indents from a line
set indentkeys-=0# " Prevent # from removing indents from a line
set wildmenu " Tab-like completion similar to zsh
set ttyfast " Smoother redraw
set formatoptions+=j " Remove comments when merging
set signcolumn=yes " Always show the signcolumn, otherwise it would shift the text each time
set shortmess+=c " Don't pass messages to |ins-completion-menu|.
set updatetime=300
set pyx=3

" Invisible characters
set list
set listchars=tab:>-

" Press % on 'if' to jump to its corresponding 'else'
runtime macros/matchit.vim

" If the backup directories do not exist, then make them
if !isdirectory($HOME . '/.vim/_backup')
    call mkdir($HOME . '/.vim/_backup')
endif

if !isdirectory($HOME . '/.vim/_swap')
    call mkdir($HOME . '/.vim/_swap')
endif

if !isdirectory($HOME . '/.vim/_undo')
    call mkdir($HOME . '/.vim/_undo')
endif

set directory=~/.vim/_swap " Set swap directory
set backupdir=~/.vim/_backup " This is the backup directory
set undofile " Allows for undos after saving
set undodir=~/.vim/_undo " This is the undo directory
set undolevels=1000 " Save a maximum of 1000 undos
set undoreload=10000 " Save undo history when reloading a file

set sessionoptions-=folds " Do not save folds

let g:clipbrdDefaultReg = '+' " Default register for clipboard

" File browsing
let g:netrw_liststyle=3
let g:netrw_browse_split = 4
let g:netrw_altv = 1

" Use different cursor for insert and normal modes depending on terminal
" Not checking &term because of a weird bug with the zsh prompt if $TERM is rxvt*
if $REALTERM =~ "rxvt"
    " 1 or 0 -> blinking block
    " 2 -> solid block
    " 3 -> blinking underscore
    " 4 -> solid underscore
    " Recent versions of xterm (282 or above) also support
    " 5 -> blinking vertical bar
    " 6 -> solid vertical bar
    let &t_SI = "\<Esc>[5 q" " Insert mode
    let &t_SR = "\<Esc>[4 q" " Replace mode
    let &t_EI = "\<Esc>[1 q" " Normal mode
endif
"}}}
"{{{ Mappings

" Map leader to space
let mapleader = "\<Space>"

nnoremap <expr> i SmartInsertModeEnter()

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice.
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Copy and paste to/from clipboard
vnoremap <C-c> "+y<CR>
inoremap <C-v> <esc>:set paste<CR>"+]p`]:set nopaste<cr>a

" Remove search highlights
nnoremap <CR> :noh<CR><CR>

" Convenient leader maps
nnoremap <Leader>w :w<CR>
nnoremap <Leader>W :w!<CR>
" Save with sudo
nnoremap <silent><Leader>W! :w !sudo tee %>/dev/null<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :q!<CR>
nnoremap <Leader>i :call Preserve('normal gg=G')<CR>
nnoremap <silent><Leader>n :call ToggleVExplorer()<CR>
nnoremap <Leader>h :split<CR>
nnoremap <Leader>v :vsplit<CR>

" Tab Mappings
nnoremap <silent> <Leader>t :tabnew<CR>

" Better k and j movement
nnoremap <silent> k gk
nnoremap <silent> j gj

" Remap jj to escape in insert mode.  You'll never type jj anyway, so it's great!
inoremap jj <Esc>

" Turn off Control-Space
imap <Nul> <Space>

" Easier page up/down
nnoremap <C-k> 3k
nnoremap <C-j> 3j
vnoremap <C-k> 3k
vnoremap <C-j> 3j

" Mundo
nnoremap <Leader>u :MundoToggle<CR>

" View highlight group under cursor
nnoremap <F3> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

nnoremap <C-p> :FZF<CR>

nnoremap <Leader>c :ALELint<CR>

" Tag navigation
" nnoremap <C-\> :tab split<CR>:exec("tjump ".expand("<cword>"))<CR>
" nnoremap <A-]> :vsplit <CR>:exec("tjump ".expand("<cword>"))<CR>

nnoremap <Backspace> <NOP>

" Better x
noremap x "_x
noremap X "_X

nnoremap <Leader>f :Rg<CR>

inoremap <silent><C-J> <C-R>=copilot#Accept("")<CR>
inoremap <silent><C-H> <C-R>=copilot#Previous()<CR>
inoremap <silent><C-K> <C-R>=copilot#Next()<CR>

"}}}
"{{{ NeoVim
if has('nvim')
    if has('clipboard') && executable('xclip')
        function! ClipboardYank()
            call system('xclip -i -selection clipboard', @@)
        endfunction

        function! ClipboardPaste()
            let @@ = system('xclip -o -selection clipboard')
        endfunction

        vnoremap <silent><C-c> y:call ClipboardYank()<CR>
        inoremap <silent><C-v> <Esc>:call ClipboardPaste()<CR>pi
    endif

    " Highlight terminal cursor red
    highlight TermCursor ctermfg=red guifg=red

    " Preserves regular <Esc> if we want to use neovim/vim in neovim terminal
    tnoremap <Esc><Esc> <C-\><C-n> " Exit terminal insert mode

    " Use :terminal to execute shell command
    nnoremap <Leader>T :terminal<CR>

    set guicursor=n-v-c:block-Cursor/lCursor-blinkon0,i-ci:ver25-Cursor/lCursor,r-cr:hor20-Cursor/lCursor " Change cursor shape based on current mode

    set inccommand=split

    " Detect if file contents have changed when re-entering
    autocmd FocusGained * checktime
endif
"}}}
"{{{ Functions

"{{{ Preserve cursor position while executing a command
function! Preserve(command)
    " preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " do the business:
    execute a:command
    " clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
"}}}

"{{{ Follow symlinks
" https://www.reddit.com/r/vim/comments/yhsn6/is_it_possible_to_work_around_the_symlink_bug/c5w91qw
function! FollowSymLink()
    let b:orig_file = fnameescape(expand('<afile>:p'))
    if getftype(b:orig_file) == 'link'
        let b:target_file = fnamemodify(resolve(b:orig_file), ':p')
        execute 'silent! edit ' . fnameescape(b:target_file)
    endif
endfunction
command! FollowSymlink call FollowSymLink()
"}}}

"{{{ Initialize statusline
function! AirlineInit()
    let g:airline_section_a = airline#section#create(["mode", " ", "paste"])
    let g:airline_section_b = airline#section#create(["branch", " ", "hunks"])
    let g:airline_section_c = airline#section#create_left(["file", "readonly"])
endfunction
"}}}

"{{{ Insert with appropriate indent on empty line
function! SmartInsertModeEnter()
    if len(getline('.')) == 0
        return "cc"
    else
        return "i"
    endif
endfunction
"}}}

"{{{ NERDTree-like file browsing
" http://stackoverflow.com/a/5636941
function! ToggleVExplorer()
    if exists("t:expl_buf_num")
        let expl_win_num = bufwinnr(t:expl_buf_num)
        if expl_win_num != -1
            let cur_win_nr = winnr()
            exec expl_win_num . 'wincmd w'
            close
            exec cur_win_nr . 'wincmd w'
            unlet t:expl_buf_num
        else
            unlet t:expl_buf_num
        endif
    else
        exec '1wincmd w'
        Vexplore
        let t:expl_buf_num = bufnr("%")
        exe "vertical resize 30"
    endif
endfunction
"}}}

"{{{ coc functions
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction
"}}}

command! -bang -nargs=* GGrep
    \ call fzf#vim#grep(
    \ 'git grep --line-number -- '.shellescape(<q-args), 0,
    \ fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

"}}}
"{{{Auto Commands

augroup defaults
    autocmd!
    autocmd BufReadPost * call FollowSymLink()
    autocmd VimEnter * call AirlineInit()
    " Restore cursor location
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    autocmd FileType * set formatoptions-=o " Override ftplugins
augroup END

" Automagically remove any trailing whitespace upon saving
autocmd BufWrite * if ! &bin | :call Preserve('silent! %s/\s\+$//ge') | endif

augroup whitespace
    let s:configuration = gruvbox_material#get_configuration()
    let s:palette = gruvbox_material#get_palette(s:configuration.background, s:configuration.foreground, s:configuration.colors_override)
    execute 'highlight ExtraWhitespace ctermbg=' . s:palette.bg_red[1] . ' guibg=' . s:palette.bg_red[0]

    autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
    " Match whitespace except when typing
    autocmd InsertEnter * match ErrorMsg /\s\+\%#\@<!$/
    autocmd InsertLeave * match ErrorMsg /\s\+$/
    autocmd BufWinLeave * call clearmatches()
augroup end

autocmd FileType python setlocal foldenable foldmethod=syntax
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType go setlocal listchars+=tab:\ \  "Trailing space

"}}}
