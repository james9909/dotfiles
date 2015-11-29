"{{{Auto Commands

augroup defaults
    autocmd!
    autocmd BufReadPost * call MyFollowSymlink(expand('<afile>'))
    autocmd VimEnter * call AirlineInit()
    autocmd VimEnter * call DetectEOL()
    " Restore cursor location
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Automagically remove any trailing whitespace that is in the file
autocmd BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

"}}}
"{{{Plugin
try
    call plug#begin('~/.vim/bundle')

    Plug 'mattn/emmet-vim', { 'for': ['html', 'css'] }
    Plug 'morhetz/gruvbox'
    Plug 'bling/vim-airline'
    Plug 'gioele/vim-autoswap'
    Plug 'ervandew/supertab'
    Plug 'Lokaltog/vim-easymotion'
    Plug 'james9909/stackanswers.vim', { 'on': 'StackAnswers' }
    Plug 'davidhalter/jedi-vim', { 'for': 'python' }
    Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
    Plug 'Raimondi/delimitMate'
    Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
    Plug 'scrooloose/syntastic'
    Plug 'airblade/vim-gitgutter'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-surround'
    Plug 'Valloric/MatchTagAlways'
    Plug 'zirrostig/vim-schlepp'

    " Syntastic
    let g:syntastic_mode_map = {'mode': 'passive'}
    let g:syntastic_always_populate_loc_list = 1
    let g:syntastic_auto_loc_list = 1
    let g:syntastic_error_symbol='✗'
    let g:syntastic_warning_symbol='⚠'
    let g:syntastic_style_error_symbol = '✗'
    let g:syntastic_style_warning_symbol = '⚠'

    " Airline
    let g:airline_powerline_fonts = 1
    let g:airline#extensions#hunks#enabled = 1
    let g:airline#extensions#hunks#hunk_symbols = ['+', 'Δ', '-']
    let g:airline#extensions#hunks#non_zero_only = 1

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

	call plug#end()
catch /:E117:/
    echom "Vim-Plug is not installed!"
endtry
"}}}
"{{{Misc Settings
syntax enable " Enable syntax highlighting
syntax sync minlines=256 " Check the first 256 lines to guess syntax highlighting to use
filetype indent on " Enable filetype-specific indentation
filetype plugin on " Enable filetype-specific plugins
let g:gruvbox_italic=1 " Enable italics
set background=dark
colorscheme gruvbox
set laststatus=2 " Always show statusline on last window
set nocompatible " Disable Vi-compatibility settings
set showcmd " Shows what you are typing as a command
set t_Co=256 " Enable 256 color
set foldmethod=marker " Folds are neat
set grepprg=grep\ -nH\ $*
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
set wildignore+=*.png,*.jpg,*.jpeg,*.gif,*.mp3 " Ignore picture and media files
set wildignore+=*.odt,*.doc,*.docx,*.pdf " Ignore formatted documents that will not render in plaintext"
set mouse=a " Enable the mouse to set cursor position
set backspace=indent,eol,start " Backspace is great
set hlsearch " Highlight search term in text
set incsearch " Show search matches as you type
set nohidden " When I close a tab, remove the buffer
set ignorecase "Ignore case when searching
set smartcase " When using an upper case letter in search, search becomes case-sensitive
set lazyredraw " Don't redraw when executing macros
set colorcolumn=80 " Highlight 80th column as guideline
set completeopt=longest,menuone,preview
set pastetoggle=<F2> " If this changes, change the paste leader above
set backup " Allow for a backup directory
set wrapscan " Automatically wrap search when hitting bottom
set scrolloff=2 " Keep cursor 2 rows above the bottom when scrolling
set linebreak " Break line on word
set timeoutlen=500 " Timeout for entering key combinations
set synmaxcol=200 " Limit syntax highlight parsing to first 200 columns
set hidden " Hides buffers instead of closing them, allows opening new buffers when current has unsaved changes
set cindent " Enable C like indentation
set cinkeys-=0# " Prevent # from removing indents from a line
set indentkeys-=0# " Prevent # from removing indents from a line
set wildmenu " Tab-like completion similar to zsh
set gdefault " g flag is on by default

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
"}}}
"{{{ Mappings

" Map leader to space
let mapleader = "\<Space>"

nnoremap <expr> i SmartInsertModeEnter()

" Vim-schlepp bindings
vmap K  <Plug>SchleppUp
vmap J  <Plug>SchleppDown
vmap H  <Plug>SchleppLeft
vmap L  <Plug>SchleppRight

" Copy and paste to/from clipboard
vnoremap <C-c> "+y<CR>
inoremap <C-v> <esc>:set paste<CR>"+]p`]:set nopaste<cr>A

" Remove search highlights
nnoremap <CR> :noh<CR><CR>

" Convenient leader maps
nnoremap <Leader>w :w<CR>
nnoremap <Leader>W :w!<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :q!<CR>
nnoremap <Leader>r :source ~/.vimrc<CR>
nnoremap <Leader>i :call Indent()<CR>
nnoremap <Leader>c :SyntasticCheck<CR>
nnoremap <Leader>rn :set relativenumber!<CR>
nnoremap <Leader>ss :setlocal spell!<CR>"
nnoremap <silent><Leader>t :call ToggleVExplorer()<CR>
nnoremap <Leader>h :split<CR>
nnoremap <Leader>v :vsplit<CR>

" Tab Mappings
nnoremap <silent> <C-l> :tabnext<CR>
nnoremap <silent> <C-h> :tabprevious<CR>
nnoremap <silent> <C-t> :tabnew<CR>

" Better k and j movement
nnoremap <silent> k gk
nnoremap <silent> j gj

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
nnoremap <silent> <F8> :execute RotateColorTheme()<CR> " Rotate colorschemes

"}}}
"{{{ Functions

"{{{ Preserve cursor position
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

"{{{ Indent file and preserve cursor position
" Re-indent the whole buffer.
function! Indent()
    call Preserve('normal gg=G')
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

"{{{ Rotate colorschemes
let themeindex=0
function! RotateColorTheme()
	let y = -1
	while y == -1
		let colorstring = "placeholder#gruvbox#Tomorrow-Night#"
		let x = match( colorstring, "#", g:themeindex )
		let y = match( colorstring, "#", x + 1 )
		let g:themeindex = x + 1
		if y == -1
			let g:themeindex = 0
		else
			let themestring = strpart(colorstring, x + 1, y - x - 1)
			hi clear
			return ":colorscheme ".themestring
		endif
	endwhile
endfunction
"}}}

"}}}
