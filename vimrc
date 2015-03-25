"{{{Auto Commands

" Automagically remove any trailing whitespace that is in the file
autocmd BufRead,BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

autocmd BufReadPost fugitive://* set bufhidden=delete

" Restore cursor position to where it was before
augroup JumpCursorOnEdit
    au!
    autocmd BufReadPost *
                \ if expand("<afile>:p:h") !=? $TEMP |
                \   if line("'\"") > 1 && line("'\"") <= line("$") |
                \      let JumpCursorOnEdit_foo = line("'\"") |
                \     let b:doopenfold = 1 |
                \     if (foldlevel(JumpCursorOnEdit_foo) > foldlevel(JumpCursorOnEdit_foo - 1)) |
                \        let JumpCursorOnEdit_foo = JumpCursorOnEdit_foo - 1 |
                \        let b:doopenfold = 2 |
                \     endif |
                \     exe JumpCursorOnEdit_foo |
                \   endif |
                \ endif
    " Need to postpone using "zv" until after reading the modelines.
    autocmd BufWinEnter *
                \ if exists("b:doopenfold") |
                \   exe "normal zv" |
                \   if(b:doopenfold > 1) |
                \       exe  "+".1 |
                \   endif |
                \   unlet b:doopenfold |
                \ endif
augroup END

"}}}
"{{{Vundle and Plugins

set rtp+=~/.vim/bundle/Vundle.vim
set rtp+=~/.vim/bundle/snippets
call vundle#begin()
filetype off

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
Plugin 'Valloric/MatchTagAlways'
Plugin 'altercation/vim-colors-solarized.git'
Plugin 'bling/vim-airline'
Plugin 'ervandew/supertab'
Plugin 'davidhalter/jedi-vim'
Plugin 'gioele/vim-autoswap'
Plugin 'godlygeek/tabular'
Plugin 'jiangmiao/auto-pairs'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tomasr/molokai'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'zirrostig/vim-schlepp'

" CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'
" Make faster
if exists("g:ctrl_user_command")
    unlet g:ctrlp_user_command
endif
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*/vendor/*,*/\.git/*
let g:ctrlp_cache_dir = $HOME . '/.cache/ctrlp'
if executable('ag')
    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
endif

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

" Neocomplete and YCM
if has('lua')
    let g:neocomplete#enable_at_startup = 1 " Enable neocomplete
    let g:neocomplete#enable_smart_case = 1 " Ignore case unless a capital letter is included
    let g:neocomplete#sources#syntax#min_keyword_length = 2 " Only show completions longer than 2 chars
    let g:neocomplete#enable_fuzzy_completion = 0 " Disable fuzzy completion
    let g:neocomplete#enable_cursor_hold_i = 1 " Enable delaying generation of autocompletions until the cursor is held
    let g:neocomplete#cursor_hold_i_time = 300 " Time to delay generation of autocompletions
    inoremap <expr><C-g> neocomplete#undo_completion()
    inoremap <expr><C-l> neocomplete#complete_common_string()
    nnoremap <Leader>a :NeoCompleteToggle<CR>
    " <CR>: close popup and save indent.
    inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
    function! s:my_cr_function()
        return pumvisible() ? neocomplete#close_popup() : "\<CR>"
    endfunction
else
    " Make YCM compatible with UltiSnips (using supertab)
    let g:ycm_key_list_select_completion = ['<C-n>', '<NOP>']
    let g:ycm_key_list_previous_completion = ['<C-p>', '<NOP>']
endif

call vundle#end()
"}}}
"{{{Misc Settings

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
set wildmode=list:longest,full
set wildignore=*.class,*.swp,*.pyc " Ignore class and swp files
set wildignore+=*.png,*.jpg,*.jpeg,*.gif " Ignore picture files
set mouse=a " Enable the mouse to set cursor position
set backspace=indent,eol,start " Backspace is great
set hlsearch " Highlight search term in text
set incsearch " Show search matches as you type
set nohidden " When I close a tab, remove the buffer
set ignorecase " Ignore cases in search
set smartcase " When using an upper case letter in search, search becomes case-sensitive
set lazyredraw " Don't redraw when executing macros
set wrap " Allow wrapping
set colorcolumn=80 " Highlight 80th column as guideline
set formatoptions-=cro " Remove auto comment
set completeopt=longest,menuone,preview
set pastetoggle=<Leader>p " If this changes, change the paste leader
set backup " Allow for a backup directory

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

let g:clipbrdDefaultReg = '+'

filetype plugin on
filetype plugin indent on

syntax enable " Enable syntax highlighting

" }}}
"{{{ Mappings

" Map leader to space
let mapleader = "\<Space>"

" Get rid of that arrow key habit
inoremap  <Up>     <NOP>
inoremap  <Down>   <NOP>
inoremap  <Left>   <NOP>
inoremap  <Right>  <NOP>
noremap   <Up>     <NOP>
noremap   <Down>   <NOP>
noremap   <Left>   <NOP>
noremap   <Right>  <NOP>

" Smart way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

nnoremap <F8> :execute RotateColorTheme()<CR>

" Vim-schlepp bindings
vmap K  <Plug>SchleppUp
vmap J  <Plug>SchleppDown
vmap H  <Plug>SchleppLeft
vmap L  <Plug>SchleppRight
vmap i  <Plug>SchleppToggleReindent

" Vim-fugitive mappings
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>
nnoremap <silent> <leader>gw :Gwrite<CR>
nnoremap <silent> <leader>gr :Gremove<CR>

" Tabularize mappings
nmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a& :Tabularize /&<CR>
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>
nmap <Leader>a, :Tabularize /,<CR>
vmap <Leader>a, :Tabularize /,<CR>
nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
vmap <Leader>a<Bar> :Tabularize /<Bar><CR>

" Swap $ and ^
noremap $ ^
noremap ^ $

" Copy and paste to/from clipboard
vnoremap <C-c> "+y<CR>
inoremap <C-v> <C-r>+

" Remove search highlights
nnoremap <CR> :noh<CR><CR>

" Convenient leader maps
nnoremap <Leader>w :w<CR>
nnoremap <Leader>W :w!<CR>
" Save with sudo
nnoremap <Leader>W! :w !sudo tee %
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :q!<CR>
nnoremap <Leader>r :source ~/.vimrc<CR>
nnoremap <Leader>i :call Indent()<CR>
nnoremap <Leader>f :CtrlP<CR>
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

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
map N Nzz
map n nzz

" Swap ; and :
nnoremap ; :
nnoremap : ;

" Remap jj to escape in insert mode.  You'll never type jj anyway, so it's great!
inoremap jj <Esc>
nnoremap JJJJ <Nop>

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

"}}}
"{{{Look and Feel

colorscheme Tomorrow-Night

" Status line
set laststatus=2
set statusline=%F%m%r%h%w\ (%{&ff}){%Y}\ [%l,%v][%p%%]

" }}}
" {{{ Functions

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

"{{{ Theme Rotating
let themeindex=0
function! RotateColorTheme()
    let y = -1
    while y == -1
        let colorstring = "placeholder#Tomorrow-Night#solarized#molokai#"
        let x = match( colorstring, "#", g:themeindex )
        let y = match( colorstring, "#", x + 1 )
        let g:themeindex = x + 1
        if y == -1
            let g:themeindex = 0
        else
            let themestring = strpart(colorstring, x + 1, y - x - 1)
            " Solarized light or dark based on time
            let hour = strftime("%H")
            if 6 <= hour && hour < 18 && g:colors_name == "Tomorrow-Night"
                set background=light
                let g:solarized_termcolors=256
                highlight Folded term=NONE cterm=NONE gui=NONE
                colorscheme solarized
                return
            elseif g:colors_name == "Tomorrow-Night"
                set background=dark
                let g:solarized_termcolors=256
                highlight Folded term=NONE cterm=NONE gui=NONE
                colorscheme solarized
                return
            endif
            return "colorscheme ".themestring
        endif
    endwhile
endfunction
" }}}

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
