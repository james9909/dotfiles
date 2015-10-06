"{{{Auto Commands

augroup defaults
    autocmd!
    autocmd VimEnter * call PluginConfig()
    autocmd VimResized * call SetStatusline()
    autocmd WinEnter * call SetStatusline()
    autocmd BufEnter * call SetStatusline()
    " Refresh git information when file is changed
    autocmd BufWritePost * call RefreshGitInfo()
augroup END

" Automagically remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

" Remove fugitive buffers
autocmd BufReadPost fugitive://* set bufhidden=delete

au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

"}}}
"{{{Vundle and Plugins

set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.vim/bundle/snippets
call vundle#begin()
filetype off

try
    " Let Vundle manage Vundle
    Plugin 'gmarik/Vundle.vim'

    " My Plugins
    Plugin 'SirVer/UltiSnips'
    " If vim has lua, use neocomplete otherwise, use YCM
    if has('lua')
        Plugin 'Shougo/neocomplete.vim'
    else
        Plugin 'Valloric/YouCompleteMe'
    endif
    Plugin 'artur-shaik/vim-javacomplete2'
    Plugin 'davidhalter/jedi-vim'
    Plugin 'ervandew/supertab'
    Plugin 'gioele/vim-autoswap'
    Plugin 'godlygeek/tabular'
    Plugin 'kien/ctrlp.vim'
    Plugin 'Lokaltog/vim-easymotion'
    Plugin 'Raimondi/delimitMate'
    Plugin 'scrooloose/nerdtree'
    Plugin 'scrooloose/syntastic'
    Plugin 'tpope/vim-commentary'
    Plugin 'tpope/vim-fugitive'
    Plugin 'tpope/vim-repeat'
    Plugin 'tpope/vim-surround'
    Plugin 'Valloric/MatchTagAlways'
    Plugin 'wellle/tmux-complete.vim'
    Plugin 'xolox/vim-notes'
    Plugin 'xolox/vim-misc'
    Plugin 'Yggdroot/indentLine'
    Plugin 'zirrostig/vim-schlepp'

    " Use git@ instead of https
    let g:vundle_default_git_proto = 'git'

    " CtrlP
    " Make faster
    if exists("g:ctrl_user_command")
        unlet g:ctrlp_user_command
    endif
    set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*
    let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
    if executable('ag')
        let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
    endif

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

    " Eclim
    let g:EclimCompletionMethod = 'omnifunc'

    " Neocomplete and YCM
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
    else
        " Make YCM compatible with UltiSnips (using supertab)
        let g:ycm_key_list_select_completion = ['<C-n>', '<NOP>']
        let g:ycm_key_list_previous_completion = ['<C-p>', '<NOP>']
        " let g:tmuxcomplete#trigger = 'omnifunc'
    endif

    " indentLine
    let g:indentLine_char = '┆'

    call vundle#end()
catch /:E117:/
    echom "Vundle not installed!"
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
set timeoutlen=300 " Timeout for entering key combinations
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

set sessionoptions-=folds      " Do not save folds

let g:clipbrdDefaultReg = '+' " Default register for clipboard

filetype plugin on
filetype plugin indent on

syntax enable " Enable syntax highlighting

" }}}
"{{{ Mappings

" Map leader to space
let mapleader = "\<Space>"

" Move between windows using alt
map <A-j> <C-W>j
map <A-k> <C-W>k
map <A-h> <C-W>h
map <A-l> <C-W>l

nnoremap <F8> :execute RotateColorTheme()<CR>

" CtrlP
noremap <C-p> :CtrlP ~<CR>

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
nnoremap <silent> <Leader>gr :Gremove<CR>

" Tabularize mappings
nmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a& :Tabularize /&<CR>
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:<CR>
vmap <Leader>a: :Tabularize /:<CR>
nmap <Leader>a:: :Tabularize /:\zs<CR>
vmap <Leader>a:: :Tabularize /:\zs<CR>
nmap <Leader>a, :Tabularize /,<CR>
vmap <Leader>a, :Tabularize /,<CR>
nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
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

" WHITESPACE
nnoremap <silent> <F9> :%s/$//g<CR>:%s// /g<CR>

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

" Change inside (ci) mappings
nnoremap <silent> c( f(ci(
nnoremap <silent> c[ f[ci[
nnoremap <silent> c< f<ci<
nnoremap <silent> c{ f{ci{
nnoremap <silent> c' f'ci'
nnoremap <silent> c" f"ci"

" Turn off Control-Space
imap <Nul> <Space>

" Easier page up/down
nnoremap <C-Up> <C-u>
nnoremap <C-Down> <C-d>
nnoremap <C-k> 3k
nnoremap <C-j> 3j
vnoremap <C-k> 3k
vnoremap <C-j> 3j

"}}}
"{{{ Custom Status Line

" Source: https://github.com/ChesleyTan/linuxrc/blob/master/vimrc
"{{{ Git
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

function! GitRemote(branch) " Note: this function takes a while to execute
    if g:inGitRepo == 0
        return ""
    endif
    let remotes=split(system("git remote")) " Get names of remotes
    if remotes==[] " End if no remotes found or error
        return ""
    else
        let remotename=remotes[0] " Get name of first remote
    endif
    let output=system("git remote show " . remotename . " | grep \"" . a:branch . "\"")
    if output =~? "local out of date"
        return " (!)Local repo out of date"
    else
        return ""
    endif
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
            let g:gitInfo=gitBranch . GitStatus() . GitRemote(gitBranch)
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
" {{{ Status Line
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
        setlocal statusline+=[%{strlen(&fenc)?&fenc:'none'}\|  " File encoding
        setlocal statusline+=%{&ff}]                           " File format
    endif
    setlocal statusline+=%r%##      " Read only flag
    setlocal statusline+=%m\%##        " Modified flag
    setlocal statusline+=%h                      " Help file flag
    setlocal statusline+=\ [B:%n/%{bufnr('$')}%##                  " Buffer number
    setlocal statusline+=\ #T:%{tabpagenr()}/%{tabpagenr('$')}]%##  " Tab number
    if winWidth > 100
        setlocal statusline+=\ %{g:gitInfo}%## " Git info
    endif
    setlocal statusline+=%=                                        " Left/right separator
    if exists("*SyntasticStatuslineFlag()")
        setlocal statusline+=%{SyntasticStatuslineFlag()}%## " Syntastic plugin flag
    endif
    "setlocal statusline+=%3*%F%*\ %4*\|%*\                        " File path with full names
    setlocal statusline+=%{pathshorten(fnamemodify(expand('%:p'),':~'))}%##\|%##  " File path with truncated names
    setlocal statusline+=C:%2c\                  " Cursor column, reserve 2 spaces
    setlocal statusline+=R:%3l/%3L               " Cursor line/total lines, reserve 3 spaces for each
    setlocal statusline+=\|%##%3p     " Percent through file, reserve 3 spaces
    setlocal statusline+=%%                      " Percent symbol
endfunction
call SetStatusline()
"}}}
"
"}}}
" {{{ Functions

" {{{ Java plugin config

function! PluginConfig()
    try
        if &filetype ==? "java"
            " if exists(":PingEclim") && !(eclim#PingEclim(0))
            "     echom "Eclimd not started"
            " endif
            " if !exists(":PingEclim") || (!(eclim#PingEclim(0)) && isdirectory(expand("$HOME/.vim/bundle/vim-javacomplete2")))
            augroup javacomplete
                let g:JavaComplete_Home = $HOME . '/.vim/bundle/vim-javacomplete2'
                let $CLASSPATH .= '.:' . $HOME . '/.vim/bundle/vim-javacomplete2/lib/javavi/target/classes'
                set omnifunc=javacomplete#Complete
            augroup END
            " else
                " echom "Eclim enabled"
            " endif
        endif
    catch
        echom "javacomplete2 is not installed!"
    endtry
endfunction

" }}}

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
" }}}

" }}}
