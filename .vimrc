"{{{Auto Commands

augroup defaults
    autocmd!
    autocmd BufReadPost * call MyFollowSymlink(expand('<afile>'))
    autocmd VimEnter * call AirlineInit()
    autocmd VimEnter * call DetectEOL()
    autocmd FileType java call JavaConfig()
    " Restore cursor location
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

" Automagically remove any trailing whitespace that is in the file
autocmd BufWrite * if ! &bin | silent! %s/\s\+$//ge | endif

"}}}
"{{{Plugins
try
    call plug#begin('~/.vim/bundle')

    Plug 'gioele/vim-autoswap'
    Plug 'mattn/emmet-vim', { 'for': ['html', 'css'] }
    Plug 'vim-scripts/DrawIt'
    Plug 'morhetz/gruvbox'
    Plug 'bling/vim-airline'
    Plug 'ervandew/supertab'
    Plug 'Lokaltog/vim-easymotion'
    Plug 'james9909/stackanswers.vim', { 'on': 'StackAnswers' }
    Plug 'davidhalter/jedi-vim', { 'for': 'python' }
    Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
    Plug 'godlygeek/tabular', { 'on': 'Tabularize' }
    Plug 'Raimondi/delimitMate'
    Plug 'suan/vim-instant-markdown', { 'for': 'markdown' }
    if has('nvim')
        Plug 'junegunn/fzf'
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
        nnoremap <C-p> :FZF<CR>

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

        Plug 'simnalamburt/vim-mundo', { 'on': 'GundoToggle' }
        Plug 'benekastah/neomake', { 'on': 'Neomake' }
        autocmd! BufWritePost * Neomake " Asynchronously check for syntax errors upon saving
    else
        if has("lua")
            Plug 'Shougo/neocomplete.vim'
            let g:neocomplete#enable_at_startup = 1 " Enable neocomplete
            let g:neocomplete#enable_smart_case = 1 " Ignore case unless a capital letter is included
            let g:neocomplete#sources#syntax#min_keyword_length = 1 " Only show completions longer than 1 chars
            let g:neocomplete#enable_fuzzy_completion = 0 " Disable fuzzy completion
            let g:neocomplete#enable_cursor_hold_i = 1 " Enable delaying generation of autocompletions until the cursor is held
            let g:neocomplete#cursor_hold_i_time = 200 " Time to delay generation of autocompletions
            autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
            " <CR>: close popup and save indent.
            inoremap <silent> <C-Space> <C-r>=<SID>my_cr_function()<CR>
            function! s:my_cr_function()
                return pumvisible() ? neocomplete#close_popup() : "\<C-Space>"
            endfunction
        endif

        Plug 'sjl/gundo.vim', { 'on': 'GundoToggle' }
        Plug 'scrooloose/syntastic'

        let g:syntastic_python_checkers = ['flake8']
        let g:syntastic_python_flake8_args = '--select=F,C9 --max-complexity=10'
        let g:syntastic_mode_map = {'mode': 'passive'}
        let g:syntastic_always_populate_loc_list = 1
        let g:syntastic_auto_loc_list = 1
        let g:syntastic_error_symbol='✗'
        let g:syntastic_warning_symbol='⚠'
        let g:syntastic_style_error_symbol = '✗'
        let g:syntastic_style_warning_symbol = '⚠'

        Plug 'ctrlpvim/ctrlp.vim'
        let g:ctrlp_show_hidden = 1
        let g:ctrlp_working_path_mode = 0 " Use vim's cwd"
        let g:ctrlp_match_window = 'bottom,order:ttb'
        " Use ag (AKA the_silver_searcher)
        if executable('ag')
            let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
                        \ --ignore .git
                        \ --ignore .svn
                        \ --ignore .hg
                        \ --ignore .DS_Store
                        \ --ignore "**/*.pyc"
                        \ --ignore _backup
                        \ --ignore _undo
                        \ --ignore _swap
                        \ --ignore .cache
                        \ -g ""'
        else
            let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
            let g:ctrlp_custom_ignore = {
                        \ 'dir':  '\v[\/](_backup|_undo|_swap|\.cache)$'
                        \ }
        endif
        nnoremap <C-p> :CtrlP<CR>
    endif
    Plug 'airblade/vim-gitgutter'
    Plug 'osyo-manga/vim-over'
    Plug 'tpope/vim-commentary'
    Plug 'tpope/vim-fugitive'
    Plug 'tpope/vim-surround'
    Plug 'Valloric/MatchTagAlways', { 'for': 'html' }
    Plug 'xolox/vim-notes'
    Plug 'xolox/vim-misc'
    Plug 'Yggdroot/indentLine'
    Plug 'zirrostig/vim-schlepp'

    " Instant markdown preview
    let g:instant_markdown_slow = 1

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

    " Vim notes
    let g:notes_word_boundaries = 1
    let g:notes_directories = ['~/Documents/vim-notes']

    " Vim-schlepp
    let g:Schlepp#allowSquishingLines = 1
    let g:Schlepp#allowSquishingBlocks = 1
    let g:Schlepp#dupTrimWS = 1

    " MatchTagAlways
    let g:mta_use_match_paren_group = 1

    " Jedi-vim
    let g:jedi#popup_on_dot = 0
    let g:jedi#popup_select_first = 0
    let g:jedi#smart_auto_mappings = 0 " Remove automatic addition of 'import' when doing 'from module<space>'

    " SuperTab
    let g:SuperTabDefaultCompletionType = '<C-n>'
    let g:SuperTabDefaultCompletionType = 'context'

    " indentLine
    let g:indentLine_char = '¦'
    let g:indentLine_color_term = 239

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
set wildignore+=*.odt,*.doc,*.docx,*.pdf " Ignore formatted documents that will not render in plaintext
set mouse=nvc " Enable the mouse for normal, visual, and command-line modes
set backspace=indent,eol,start " Backspace is great
set hlsearch " Highlight search term in text
set incsearch " Show search matches as you type
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
set synmaxcol=300 " Limit syntax highlight parsing to first 300 columns
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

" Vim-schlepp bindings
vmap K  <Plug>SchleppUp
vmap J  <Plug>SchleppDown
vmap H  <Plug>SchleppLeft
vmap L  <Plug>SchleppRight

" Vim-fugitive mappings
nnoremap <silent> <Leader>gs :Gstatus<CR>
nnoremap <silent> <Leader>gd :Gdiff<CR>
nnoremap <silent> <Leader>gc :Gcommit<CR>
nnoremap <silent> <Leader>gb :Gblame<CR>
nnoremap <silent> <Leader>gl :Glog<CR>
nnoremap <silent> <Leader>gp :Git push<CR>
nnoremap <silent> <Leader>gw :Gwrite<CR>

" Tabularize mappings
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
nnoremap <silent><Leader>W! :w !sudo tee %>/dev/null<CR>
nnoremap <Leader>q :q<CR>
nnoremap <Leader>Q :q!<CR>
nnoremap <Leader>r :source ~/.vimrc<CR>
nnoremap <Leader>i :call Indent()<CR>
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

" Syntax checker
if has("nvim")
    nnoremap <Leader>c :Neomake<CR>
    " Use :terminal to execute shell command
    nnoremap <Leader>T :terminal<CR>
else
    nnoremap <Leader>c :SyntasticCheck<CR>
endif

"}}}
"{{{ NeoVim
if has('nvim')
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

    " Highlight terminal cursor red
	highlight TermCursor ctermfg=red guifg=red

    " Preserves regular <Esc> if we want to use neovim/vim in neovim terminal
    tnoremap <Esc><Esc> <C-\><C-n> " Exit terminal insert mode

    let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
endif
"}}}
"{{{ Functions

"{{{ Java plugin config

function! JavaConfig()
    try
        let g:JavaComplete_Home = $HOME . '/.vim/bundle/vim-javacomplete2'
        let $CLASSPATH .= '.:' . $HOME . '/.vim/bundle/vim-javacomplete2/lib/javavi/target/classes'
        let g:JavaComplete_UseFQN = 1
        let g:JavaComplete_ServerAutoShutdownTime = 300
        set omnifunc=javacomplete#Complete
    catch
        echom "javacomplete2 is not installed!"
    endtry
endfunction

"}}}

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
command! TransparentBackground call TransparentBackground()
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
