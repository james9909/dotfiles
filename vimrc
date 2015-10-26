"{{{Auto Commands

augroup defaults
    autocmd!
    autocmd BufReadPost * call MyFollowSymlink(expand('<afile>'))
    " autocmd VimEnter * call PluginConfig()
    autocmd VimResized * call SetStatusline()
    autocmd WinEnter * call SetStatusline()
    autocmd BufEnter * call SetStatusline()
    autocmd BufEnter * silent! lcd %:p:h
    " Refresh git information when file is changed
    autocmd BufWritePost * call RefreshGitInfo()
augroup END

" Automagically remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Remove fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

"}}}
"{{{ NeoVim
if has('nvim')
    let g:scriptsDirectory = expand("$HOME/.vim/scripts/")

    if has('clipboard')
        function! ClipboardYank()
            call system('xclip -i -selection clipboard', @@)
        endfunction

        function! ClipboardPaste()
            let @@ = system('xclip -o -selection clipboard')
        endfunction
        vnoremap <silent> y y:call ClipboardYank()<cr>
        vnoremap <silent> d d:call ClipboardYank()<cr>
        nnoremap <silent> p :call ClipboardPaste()<cr>p
    endif

    tnoremap <Esc> <C-\><C-n>   " Escape to exit terminal insert mode
    tnoremap jj <C-\><C-n>      " jj to exit terminal insert mode
    " Use :terminal to execute shell command
    nnoremap <Leader>c :terminal

endif
"}}}
"{{{NeoBundle and Plugins

filetype off

try
    set runtimepath+=~/.vim/bundle/neobundle.vim/
    call neobundle#begin(expand('~/.vim/bundle'))

    " Let Neobundle manage NeoBundle
    NeoBundleFetch 'Shougo/neobundle.vim'

    if has('lua')
        NeoBundle 'Shougo/neocomplete.vim'
    endif
    NeoBundle 'gioele/vim-autoswap'
    NeoBundle 'ervandew/supertab'

    NeoBundle 'Lokaltog/vim-easymotion'
    NeoBundleLazy 'davidhalter/jedi-vim', {
        \'autoload': {
            \'filetypes': 'python'
        \}
    \}
    NeoBundleLazy 'artur-shaik/vim-javacomplete2', {
        \'autoload': {
            \'filetypes': 'java'
        \}
    \}
    NeoBundleLazy 'scrooloose/nerdtree', {
        \'autoload': {
            \'commands': 'NERDTreeToggle'
        \}
    \}
    NeoBundleLazy 'scrooloose/syntastic', {
        \'autoload': {
            \'commands': 'SyntasticCheck'
        \}
    \}
    NeoBundleLazy 'godlygeek/tabular', {
        \'autoload': {
            \'commands': 'Tabularize'
        \}
    \}
    NeoBundleLazy 'Raimondi/delimitMate', {
        \'autoload': {
            \'insert': 1,
            \'filetypes': 'all'
        \}
    \}
    if has('nvim')
        NeoBundleLazy 'simnalamburt/vim-mundo', {
            \'autoload': {
                \'commands': 'GundoToggle'
            \}
        \}
    else
        NeoBundleLazy 'sjl/gundo.vim', {
            \'autoload': {
                \'commands': 'GundoToggle'
            \}
        \}
    endif
    NeoBundle 'osyo-manga/vim-over'
    NeoBundle 'SirVer/UltiSnips'
    NeoBundle 'tpope/vim-commentary'
    NeoBundle 'tpope/vim-fugitive'
    NeoBundle 'tpope/vim-surround'
    NeoBundle 'Valloric/MatchTagAlways'
    NeoBundle 'wellle/tmux-complete.vim'
    NeoBundle 'xolox/vim-notes'
    NeoBundle 'xolox/vim-misc'
    NeoBundle 'Yggdroot/indentLine'
    NeoBundle 'zirrostig/vim-schlepp'

    " Gundo
    let g:gundo_width = 30
    let g:gundo_preview_height = 15
    let g:gundo_preview_bottom = 1

    " DelimitMate
    let g:delimitMate_expand_inside_quotes = 1
    let g:delimitMate_expand_cr = 1

    " Vim notes
    let g:notes_word_boundaries = 1
    let g:notes_directories = ['~/Documents/vim-notes']

    " Better key bindings for UltiSnipsExpandTrigger
    let g:UltiSnipsExpandTrigger = "<tab>"
    let g:UltiSnipsJumpForwardTrigger = "<tab>"
    let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
    let g:UltiSnipsEditSplit="vertical"
    let g:UltiSnipsSnippetsDir        = $HOME.'/.vim/UltiSnips/'
    let g:UltiSnipsSnippetDirectories=["UltiSnips"]

    " Syntastic
    let g:syntastic_mode_map = {'mode': 'passive'}
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_check_on_open = 1
    let g:syntastic_check_on_wq = 1
    let python_highlight_all = 1
    let g:syntastic_error_symbol='✗'
    let g:syntastic_warning_symbol='⚠'
    let g:syntastic_style_error_symbol = '✗'
    let g:syntastic_style_warning_symbol = '⚠'

    " Vim-schlepp
    let g:Schlepp#allowSquishingLines = 1
    let g:Schlepp#allowSquishingBlocks = 1
    let g:Schlepp#dupTrimWS = 1

    " MatchTagAlways
    let g:mta_use_match_paren_group = 1

    " Jedi-vim
    let g:jedi#popup_on_dot = 0
    let g:jedi#popup_select_first = 0

    " SuperTab
    let g:SuperTabDefaultCompletionType = '<C-n>'
    let g:SuperTabDefaultCompletionType = 'context'

    " " Eclim
    " let g:EclimCompletionMethod = 'omnifunc'

    if has('lua')
        let g:neocomplete#enable_at_startup = 1 " Enable neocomplete
        let g:neocomplete#enable_smart_case = 1 " Ignore case unless a capital letter is included
        let g:neocomplete#sources#syntax#min_keyword_length = 2 " Only show completions longer than 2 chars
        let g:neocomplete#enable_fuzzy_completion = 0 " Disable fuzzy completion
        let g:neocomplete#enable_cursor_hold_i = 1 " Enable delaying generation of autocompletions until the cursor is held
        let g:neocomplete#cursor_hold_i_time = 200 " Time to delay generation of autocompletions
        autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
        autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
        autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
        autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
        inoremap <expr><C-g> neocomplete#undo_completion()
        inoremap <expr><C-l> neocomplete#complete_common_string()
        nnoremap <Leader>a :NeoCompleteToggle<CR>
        " <CR>: close popup and save indent.
        inoremap <silent> <C-Space> <C-r>=<SID>my_cr_function()<CR>
        function! s:my_cr_function()
            return pumvisible() ? neocomplete#close_popup() : "\<C-Space>"
        endfunction
        let g:tmuxcomplete#trigger  = 'omnifunc' " Integrate into neocomplete
    endif

    " indentLine
    let g:indentLine_char = '┆'

    call neobundle#end()
catch /:E117:/
    echom "NeoBundle is not installed!"
endtry
"}}}
"{{{ Variables
let g:showGitInfo = 1 " This determines whether to show git info in statusline
let g:inGitRepo = 0
let g:gitInfo = "" " Placeholder value to initialize variable
"}}}
"{{{Misc Settings

colorscheme Tomorrow-Night
set laststatus=2 " Always show statusline on last window
set nocompatible " Disable Vi-compatibility settings
set showcmd " Shows what you are typing as a command
set t_Co=256 " Enable 256 color
set foldmethod=marker " Folds are neat
set grepprg=grep\ -nH\ $*
set expandtab " Tabs are spaces
set smarttab " Enable smart tabbing
set shiftwidth=4 " Tab size for auto indent
set softtabstop=4 " A tab is 4 spaces
set autoindent " Autoindent
set copyindent " Copies the indentation of the previous line
set smartindent " Enable smart indents
set number " Enable line numbers
set wrap " Wrap lines
set wildmode=list:longest,full
set wildignore=*.class,*.swp,*.pyc,*.jar,*.cmake,*.tar.* " Ignore compiled things
set wildignore+=*.png,*.jpg,*.jpeg,*.gif,*.mp3 " Ignore picture and media files
set wildignore+=*.odt,*.doc,*.docx,*.pdf " Ignore formatted documents that will not render in plaintext"
set mouse=a " Enable the mouse to set cursor position
set backspace=indent,eol,start " Backspace is great
set hlsearch " Highlight search term in text
set incsearch " Show search matches as you type
set nohidden " When I close a tab, remove the buffer
set ignorecase " Ignore cases in search
set smartcase " When using an upper case letter in search, search becomes case-sensitive
set lazyredraw " Don't redraw when executing macros
set colorcolumn=80 " Highlight 80th column as guideline
set formatoptions-=cro " Remove auto comment
set completeopt=longest,menuone,preview
set pastetoggle=<Leader>p " If this changes, change the paste leader
set backup " Allow for a backup directory
set wrapscan " Automatically wrap search when hitting bottom
set scrolloff=2 " Keep cursor 2 rows above the bottom when scrolling
set linebreak " Break line on word
set timeoutlen=500 " Timeout for entering key combinations
set synmaxcol=150 " Limit syntax highlight parsing to first 150 columns
set hidden " Hides buffers instead of closing them, allows opening new buffers when current has unsaved changes

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

filetype plugin on
filetype plugin indent on

syntax enable " Enable syntax highlighting

"}}}
"{{{ Mappings

" Map leader to space
let mapleader = "\<Space>"

" Move between windows using alt
map <A-j> <C-W>j
map <A-k> <C-W>k
map <A-h> <C-W>h
map <A-l> <C-W>l

" Vim-schlepp bindings
vmap K  <Plug>SchleppUp
vmap J  <Plug>SchleppDown
vmap H  <Plug>SchleppLeft
vmap L  <Plug>SchleppRight
vmap i  <Plug>SchleppToggleReindent

" Vim-fugitive mappings
nnoremap <silent> <Leader>gs :Gstatus<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gc :Gcommit<CR>
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>gl :Glog<CR>
nnoremap <silent> <Leader>gp :Git push<CR>
nnoremap <silent> <Leader>gw :Gwrite<CR>

" Tabularize mappings
vmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a: :Tabularize /:<CR>
vmap <Leader>a:: :Tabularize /:\zs<CR>
vmap <Leader>a, :Tabularize /,<CR>
vmap <Leader>a<Bar> :Tabularize /<Bar><CR>

" Copy and paste to/from clipboard
vnoremap <C-c> "+y<CR>
inoremap <C-v> <esc>:set paste<CR>"+]p`]:set nopaste<cr>A

" Remove search highlights
nnoremap <CR> :noh<CR><CR>

" Convenient leader maps
nnoremap <Leader>w :w<CR>
nnoremap <Leader>W :w!<CR>
" Save with sudo
nnoremap <Leader>W! :w !sudo tee %<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :q!<CR>
nnoremap <Leader>r :source ~/.vimrc<CR>
nnoremap <Leader>i :call Indent()<CR>
nnoremap <Leader>c :SyntasticCheck<CR>
nnoremap <Leader>rn :set relativenumber!<CR>
nnoremap <Leader>ss :setlocal spell!<CR>"
nnoremap <Leader>t :NERDTreeToggle<CR>
nnoremap <Leader>h :split<CR>
nnoremap <Leader>v :vsplit<CR>
nnoremap <silent> <Leader>ev :tabnew<CR>:e ~/.vimrc<CR>
" If this changes, change the pastetoggle mapping above
nnoremap <silent> <Leader>p :call Paste_on_off()<CR>

" Tab Mappings
nnoremap <silent> <C-Right> :tabnext<CR>
nnoremap <silent> <C-Left> :tabprevious<CR>
nnoremap <silent> <C-t> :tabnew<CR>

" Better k and j movement
nnoremap <silent> k gk
nnoremap <silent> j gj

" Create Blank Newlines and stay in Normal mode
nnoremap <silent> zj o<Esc>
nnoremap <silent> zk O<Esc>

" Swap ; and :
nnoremap ; :
nnoremap : ;

" Remap jj to escape in insert mode.  You'll never type jj anyway, so it's great!
inoremap jj <Esc>

" Go to the end of the line pasted
vnoremap <silent> p p`]
nnoremap <silent> p p`]

" Turn off Control-Space
imap <Nul> <Space>

" Easier page up/down
nnoremap <C-Up> <C-u>
nnoremap <C-Down> <C-d>
nnoremap <C-k> 3k
nnoremap <C-j> 3j
vnoremap <C-k> 3k
vnoremap <C-j> 3j

" Gundo
nnoremap <Leader>u :GundoToggle<CR>

"}}}
"{{{ Custom Status Line

" Source: https://github.com/ChesleyTan/linuxrc/blob/master/vimrc
"{{{ Git
"
function! Git()
    if exists('$NVIM_LISTEN_ADDRESS')
        call system('python ' . g:scriptsDirectory . 'git.py $NVIM_LISTEN_ADDRESS $PWD &')
    endif
endfunction

function! GitBranch()
    let output=system("git branch | grep '*' | grep -o '[^* ]*'")
    if output=="" || output=~?"fatal"
        return ""
    else
        let g:inGitRepo=1
        return "[Git][" . output[0 : strlen(output)-2] . " " " Strip newline ^@
    endif
endfunction

function! GitStatus()
    if g:inGitRepo == 0
        return ""
    endif
    let output=system('git status')
    let retStr=""
    if output=~?"Changes to be committed"
        let retStr.="\u2718"
    else
        let retStr.="\u2714"
    endif
    if output=~?"modified"
        let retStr.=" \u0394"
    endif
    let retStr.=GitStashLength() . "]"
    return retStr
endfunction

function! GitStashLength()
    if g:inGitRepo == 0
        return ""
    endif
    let stashLength=system("git stash list | wc -l")
    if stashLength=="0\n" || stashLength=="" || stashLength=~?"fatal"
        return ""
    else
        return " \u26c1 " . stashLength[0 : strlen(stashLength)-2] " Strip trailing newline
    endif
endfunction

function! RefreshGitInfo()
    if g:showGitInfo == 1
        " If nvim, use asynchronous msgpack-rpc method
        if has('nvim')
            call Git()
            " Otherwise, use standard synchronous method
        else
            let gitBranch=GitBranch()
            let g:gitInfo=gitBranch . GitStatus()
        endif
    else
        let g:gitInfo = "" " Clear old git info
    endif
endfunction
function! ToggleGitInfo()
    if g:showGitInfo == 1
        let g:showGitInfo = 0
    else
        let g:showGitInfo = 1
    endif
endfunction
command! ToggleGitInfo call ToggleGitInfo()
call RefreshGitInfo()
"}}}
"{{{ Status Line
function! SetStatusline()
    let bufName = bufname('%')
    " Do not modify the statusline for NERDTree
    if bufName =~# "NERD"
        return
    endif
    let winWidth = winwidth(0)
    setlocal statusline=""
    if winWidth > 50
        setlocal statusline+=%t " Tail of the filename
    endif
    if winWidth > 40
        setlocal statusline+=%y " Filetype
    endif
    if winWidth > 80
        setlocal statusline+=[%{&ff}] " File format
    endif
    setlocal statusline+=%r%## " Read only flag
    setlocal statusline+=%m\%## " Modified flag
    setlocal statusline+=%h " Help file flag
    if winWidth > 100
        setlocal statusline+=\ %{g:gitInfo}%## " Git info
    endif
    setlocal statusline+=%= " Left/right separator
    if exists("*SyntasticStatuslineFlag()")
        setlocal statusline+=%{SyntasticStatuslineFlag()}%## " Syntastic plugin flag
    endif
    "setlocal statusline+=%3*%F%*\ %4*\|%*\                        " File path with full names
    setlocal statusline+=%{pathshorten(fnamemodify(expand('%:p'),':~'))}%##\|%##  " File path with truncated names
    setlocal statusline+=C:%2c\  " Cursor column, reserve 2 spaces
    setlocal statusline+=R:%3l/%3L " Cursor line/total lines, reserve 3 spaces for each
    setlocal statusline+=\|%##%3p " Percent through file, reserve 3 spaces
    setlocal statusline+=%% " Percent symbol
endfunction
call SetStatusline()
"}}}
"
"}}}
"{{{ Functions

"{{{ Java plugin config

" function! PluginConfig()
"     try
"         if &filetype ==? "java"
"             " if exists(":PingEclim") && !(eclim#PingEclim(0))
"             "     echom "Eclimd not started"
"             " endif
"             " if !exists(":PingEclim") || (!(eclim#PingEclim(0)) && isdirectory(expand("$HOME/.vim/bundle/vim-javacomplete2")))
"             augroup javacomplete
"                 let g:JavaComplete_Home = $HOME . '/.vim/bundle/vim-javacomplete2'
"                 let $CLASSPATH .= '.:' . $HOME . '/.vim/bundle/vim-javacomplete2/lib/javavi/target/classes'
"                 set omnifunc=javacomplete#Complete
"             augroup END
"             " else
"                 " echom "Eclim enabled"
"             " endif
"         endif
"     catch
"         echom "javacomplete2 is not installed!"
"     endtry
" endfunction

"}}}

"{{{ AutoIndent upon saving
" Restore cursor position, window position, and last search after running a
" command.
function! Preserve(command)
    " Save the last search.
    let search = @/

    " Save the current cursor position.
    let cursor_position = getpos('.')

    " Save the current window position.
    normal! H
    let window_position = getpos('.')
    call setpos('.', cursor_position)

    " Execute the command.
    execute a:command

    " Restore the last search.
    let @/ = search

    " Restore the previous window position.
    call setpos('.', window_position)
    normal! zt

    " Restore the previous cursor position.
    call setpos('.', cursor_position)
endfunction

" Re-indent the whole buffer.
function! Indent()
    call Preserve('normal gg=G')
endfunction
"}}}

"{{{ Paste Toggle
let paste_mode = 0 " 0 = normal, 1 = paste

func! Paste_on_off()
    if g:paste_mode == 0
        set paste
        let g:paste_mode = 1
        echo "Paste mode on"
    else
        set nopaste
        let g:paste_mode = 0
        echo "Paste mode off"
    endif
    return
endfunc
"}}}

"{{{ Transparent background
function! TransparentBackground()
    highlight clear CursorLine
    highlight Normal ctermbg=none
    highlight LineNr ctermbg=none
    highlight Folded ctermbg=none
    highlight NonText ctermbg=none
    highlight SpecialKey ctermbg=none
    highlight VertSplit ctermbg=none
    highlight SignColumn ctermbg=none
endfunction
"}}}

"{{{ Follow symlinks
" Credits to https://github.com/blueyed/dotfiles/commit/1287a5897a15c11b6c05ca428c4a5e6322bd55e8
function! MyFollowSymlink(...)
    if exists('w:no_resolve_symlink') && w:no_resolve_symlink
        return
    endif
    let fname = a:0 ? a:1 : expand('%')
    if fname =~ '^\w\+:/'
        " Do not mess with 'fugitive://' etc
        return
    endif
    let fname = simplify(fname)

    let resolvedfile = resolve(fname)
    if resolvedfile == fname
        return
    endif
    let resolvedfile = fnameescape(resolvedfile)
    echohl WarningMsg | echomsg 'Resolving symlink' fname '=>' resolvedfile | echohl None
    " Use file, since edit doesn't work
    exec 'file ' . resolvedfile
endfunction
command! FollowSymlink call MyFollowSymlink()
command! ToggleFollowSymlink let w:no_resolve_symlink = !get(w:, 'no_resolve_symlink', 0) | echo "w:no_resolve_symlink =>" w:no_resolve_symlink
"}}}

"}}}
