"{{{Plugins
try
    call plug#begin('~/.vim/bundle')

    if has('nvim')
        " We are using neovim

        Plug 'Shougo/deoplete.nvim'
        let g:deoplete#enable_at_startup = 1 " Enable deoplete
        let g:deoplete#enable_smart_case = 1 " Ignore case unless a capital letter is included
        let g:deoplete#enable_fuzzy_completion = 0 " Disable fuzzy completion
        let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
        let g:deoplete#omni#input_patterns.java = [
                    \'[^. \t0-9]\.\w*',
                    \'[^. \t0-9]\->\w*',
                    \'[^. \t0-9]\::\w*',
                    \'\s[A-Z][a-z]',
                    \'^\s*@[A-Z][a-z]'
                    \]
        let g:deoplete#omni#input_patterns.javascript = [
                    \'[^. \t0-9]\.([a-zA-Z_]\w*)?'
                    \]

        Plug 'carlitux/deoplete-ternjs'
        Plug 'simnalamburt/vim-mundo', { 'on': 'GundoToggle' }
        Plug 'zchee/deoplete-jedi'

        " Tern
        let g:tern_request_timeout = 1
        let g:tern_show_signature_in_pum = '0'  " This do disable full signature type on autocomplete

    else
        " We are using vim

        " if v:version >= 800
        "     " Asynchronous completion if we are using vim 8
        "    Plug 'maralla/completor.vim'
        "     let g:completor_java_omni_trigger = '[^. *\t]\.\w*'

        "     let g:completor_racer_binary = '/home/james/.cargo/bin/racer'
        " else
        "     " Lua is not available, so use lightweight completion plugin instead
        "     Plug 'ajh17/VimCompletesMe'
        " endif
        Plug 'Valloric/YouCompleteMe', { 'do': './install.py --gocode-completer --tern-completer --racer-completer' }

        Plug 'davidhalter/jedi-vim', { 'for': 'python' }
        Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }

        " Jedi-vim
        let g:jedi#popup_select_first = 0
        let g:jedi#smart_auto_mappings = 0 " Remove automatic addition of 'import' when doing 'from module<space>'
    endif
    Plug 'Raimondi/delimitMate'
    Plug 'Valloric/MatchTagAlways', { 'for': 'html' }
    Plug 'Yggdroot/indentLine'
    Plug 'alvan/vim-closetag'
    Plug 'airblade/vim-gitgutter'
    " Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
    Plug 'bling/vim-airline'
    Plug 'gioele/vim-autoswap'
    Plug 'fatih/vim-go', { 'for': 'go' }
    Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }
    Plug 'james9909/stackanswers.vim', { 'on': 'StackAnswers' }
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    Plug 'junegunn/fzf.vim'
    Plug 'kchmck/vim-coffee-script'
    Plug 'Konfekt/FastFold'
    Plug 'ludovicchabant/vim-gutentags'
    Plug 'morhetz/gruvbox'
    Plug 'mxw/vim-jsx'
    Plug 'pangloss/vim-javascript'
    Plug 'pearofducks/ansible-vim'
    Plug 'Rip-Rip/clang_complete', { 'for': 'c', 'dir': '~/.vim/bundle/clang_complete', 'do': 'make install' }
    Plug 'racer-rust/vim-racer'
    Plug 'rust-lang/rust.vim'
    Plug 'neomake/neomake'
    Plug 'suan/vim-instant-markdown', { 'for': 'markdown' }
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-surround'
    Plug 'vimwiki/vimwiki'

    if executable('ag')
        let $FZF_DEFAULT_COMMAND = 'ag -i --nocolor --nogroup --hidden
                    \ --ignore .git
                    \ --ignore .DS_Store
                    \ --ignore "**/*.pyc"
                    \ --ignore "**/*.class"
                    \ --ignore _backup
                    \ --ignore _undo
                    \ --ignore _swap
                    \ --ignore .cache
                    \ -g ""'
    endif
    let g:fzf_layout = { 'down': '~40%' }

    " Fix conflict with delimitmate
    let g:closetag_filenames = "*.xml,*.html,*.php"
    au FileType xml,html,htmldjango,php let b:delimitMate_matchpairs = "(:),[:],{:}"

    " Instant markdown preview
    let g:instant_markdown_autostart = 0 " Don't automatically open a preview
    let g:instant_markdown_slow = 1 " Only update after saving

    " Airline
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#hunks#enabled = 1
    let g:airline#extensions#hunks#hunk_symbols = ['+', 'Δ', '-']
    let g:airline#extensions#hunks#non_zero_only = 1
    let g:airline#extensions#virtualenv#enabled = 1

    " Git Gutter
    let g:gitgutter_sign_added = "+"
    let g:gitgutter_sign_modified = "Δ"
    let g:gitgutter_sign_removed = "-"
    let g:gitgutter_sign_removed_first_line = '^'
    let g:gitgutter_sign_modified_removed = 'Δ-'

    " Gundo
    let g:gundo_width = 30
    let g:gundo_preview_height = 15
    let g:gundo_preview_bottom = 1

    " DelimitMate
    let g:delimitMate_expand_inside_quotes = 1
    let g:delimitMate_expand_cr = 1
    let g:delimitMate_nesting_quotes = ['"', '`', '"']

    " Vim wiki
    let g:vimwiki_list = [{'path':'~/Documents/Google Drive/School/Notes', 'path_html':'~/Documents/Google Drive/School/Notes/export/html/'}]
    let g:vimwiki_folding='expr'

    " MatchTagAlways
    let g:mta_use_match_paren_group = 1

    " indentLine
    let g:indentLine_char = '¦'
    let g:indentLine_color_term = 239

    " Gutentags
    let g:gutentags_ctags_tagfile = ".tags"
    let g:gutentags_ctags_exclude = ["*.min.js", "*.min.css", "build", "vendor", ".git", "node_modules"]

    " vim-clang
    let g:clang_library_path='/usr/lib/llvm-3.6/lib/libclang.so.1'

    " Get rid of conflicting whitespace errors
    hi link coffeeSpaceError NONE

    " Disable errors for the fmt command
    let g:go_fmt_fail_silently = 1
    let g:go_fmt_command = "goimports"

    " Allow JSX syntax highlighting in .js files
    let g:jsx_ext_required = 0

    " Run :RustFmt when saving a buffer
    let g:rustfmt_autosave = 1

    " Racer
    let g:racer_cmd = "~/.cargo/bin/racer"
    let g:racer_experimental_completer = 1

    call plug#end()
catch /:E117:/
    echom "Vim-Plug is not installed!"
endtry
"}}}
"{{{Auto Commands

augroup defaults
    autocmd!
    autocmd BufReadPost * call FollowSymLink()
    autocmd VimEnter * call AirlineInit()
    autocmd VimEnter * call DetectEOL()
    " autocmd FileType java call JavaConfig()
    " Restore cursor location
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

    autocmd FileType * set formatoptions-=o " Override ftplugins
    autocmd! BufWritePost * if &ft != "java" | Neomake | endif " Asynchronously check for syntax errors upon saving
augroup END

" Automagically remove any trailing whitespace upon saving
autocmd BufWrite * if ! &bin | :call Preserve('silent! %s/\s\+$//ge') | endif

augroup whitespace
    autocmd BufWinEnter * match ErrorMsg /\s\+$/
    " Match whitespace except when typing
    autocmd InsertEnter * match ErrorMsg /\s\+\%#\@<!$/
    autocmd InsertLeave * match ErrorMsg /\s\+$/
    autocmd BufWinLeave * call clearmatches()
augroup end

autocmd FileType ruby setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType vimwiki setlocal spell
autocmd FileType rust nmap K <Plug>(rust-doc)
autocmd FileType python setlocal foldenable foldmethod=syntax

"}}}
"{{{Misc Settings
filetype off " Clear filetype
filetype plugin indent on " Enable filetype-specific indentation and plugins
syntax on " Enable syntax highlighting
let g:gruvbox_italic=1 " Enable italics
set background=dark
colorscheme gruvbox " Gruvbox runs 'syntax reset' anyways
set cursorline " Highlight current line
set laststatus=2 " Always show statusline on last window
set showcmd " Shows what you are typing as a command
set t_Co=256 " Enable 256 color
set foldmethod=marker " Folds are neat
set grepprg=grep\ -nH\ $* " Set command for :grep
set expandtab " Tabs are spaces
set smarttab " Enable smart tabbing
set shiftwidth=4 " Tab size for auto indent
set shiftround " Round indent to multiple of shiftwidth when using > or <
set tabstop=4 " A tab is 4 columns
set softtabstop=4 " A tab is 4 spaces
set autoindent " Autoindent
set copyindent " Copies the indentation of the previous line
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
set colorcolumn=80 " Highlight 80th column as guideline
set completeopt=longest,menuone
set pastetoggle=<F2> " Toggle paste mode
set backup " Allow for a backup directory
set wrapscan " Automatically wrap search when hitting bottom
set scrolloff=2 " Keep cursor 2 rows above the bottom when scrolling
set linebreak " Break line on word
set timeoutlen=500 " Timeout for entering key combinations
set synmaxcol=300 " Limit syntax highlight parsing to first 300 columns
set hidden " Hides buffers instead of closing them, allows opening new buffers when current has unsaved changes
set cindent " Enable C like indentation
set cinkeys-=0# " Prevent # from removing indents from a line
set indentkeys-=0# " Prevent # from removing indents from a line
set wildmenu " Tab-like completion similar to zsh
set ttyfast " Smoother redraw
set formatoptions+=j " Remove comments when merging

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

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

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
nnoremap <silent> <Tab> gt
nnoremap <silent> <S-Tab> gT

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

" Gundo
nnoremap <Leader>u :GundoToggle<CR>

" View highlight group under cursor
nnoremap <F3> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
            \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
            \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

nnoremap <C-p> :FZF<CR>

nnoremap <Leader>c :Neomake<CR>

" Tag navigation
nnoremap <C-\> :tab split<CR>:exec("tjump ".expand("<cword>"))<CR>
nnoremap <A-]> :vsplit <CR>:exec("tjump ".expand("<cword>"))<CR>

nnoremap <Backspace> <NOP>
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

endif
"}}}
"{{{ Functions

"{{{ Java plugin config

function! JavaConfig()
    " Eclim is not enabled, but javacomplete2 is installed
    " if !exists(":PingEclim") || (!(eclim#PingEclim(0)) && isdirectory(expand("$HOME/.vim/bundle/vim-javacomplete2")))
        let g:JavaComplete_Home = $HOME . '/.vim/bundle/vim-javacomplete2'
        let $CLASSPATH .= '.:' . $HOME . '/.vim/bundle/vim-javacomplete2/lib/javavi/target/classes'
        let g:JavaComplete_UseFQN = 1
        let g:JavaComplete_ServerAutoShutdownTime = 300
        setlocal omnifunc=javacomplete#Complete

        " " Running gvim embedded within eclipse
    " elseif eclim#PingEclim(0) && has("gui_running")
        " set guioptions-=m " Remove menu bar
        " set guioptions-=T " Remove toolbar
        " set ruler " Show line/column numbers
        " set laststatus=0 " Disable statusline
    " elseif eclim#PingEclim(0)
        " echom "Eclim is running"
    " else
        " echom "Neither eclim nor javacomplete2 is installed"
    " endif
endfunction

"}}}

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

"{{{ Detect binary files
function! DetectEOL()
    if &endofline == 0
        set noendofline
        set binary
    endif
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

"}}}
