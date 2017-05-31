set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Bundle 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'tpope/vim-fugitive'
Plugin 'tmhedberg/simpylfold'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'kien/ctrlp.vim'
Plugin 'joom/vim-commentary'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'maralla/completor.vim'
Plugin 'tpope/vim-surround'
" Plugin 'nvie/vim-flake8'
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line


"  -----------------------
" Vim defaults overriding
"  -----------------------
set timeoutlen=1000 ttimeoutlen=0" Fix bug with backspace " Remove timeout
set backspace=indent,eol,start " Fix bug
set clipboard=unnamed

"autocmd Filetype python nnoremap <buffer> <F5> :exec '!python' shellescape(@%, 1)<cr>
autocmd Filetype python nnoremap <buffer> <F5> :exec 'w !python'<cr>

" Mac OS X clipboard integration
nmap <F1> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
vmap <F2> :w !pbcopy<CR><CR

" setting for vim-visual-page-percent
set statusline+=%{VisualPercent()}
set statusline=%<\ %n:%F\ %m%r%y%=%-35.(L:\ %l\ /\ %L,\ C:\ %c%V\ (%P)%)
set hls

" no temp or backup files
set noswapfile
set nobackup
set nowritebackup

"  -----------------------
" Vim defaults overriding
"  -----------------------

" Remap <Leader> key
let mapleader = ","

" Don't cancel visual select when shifting
vnoremap < <gv
vnoremap > >gv

" Visual linewise up and down by default (and use gj gk to go quicker)
nnoremap j gj
nnoremap k gk
nnoremap gj 5j
nnoremap gk 5k
vnoremap j gj
vnoremap k gk
vnoremap gj 5j
vnoremap gk 5k

" When jump to next match also center screen
nnoremap n nzz
nnoremap N Nzz
vnoremap n nzz
vnoremap N Nzz

" Same when moving up and down
nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz
nnoremap <C-f> <C-f>zz
nnoremap <C-b> <C-b>zz
vnoremap <C-u> <C-u>zz
vnoremap <C-d> <C-d>zz
vnoremap <C-f> <C-f>zz
vnoremap <C-b> <C-b>zz

"  -----------------------
"  Mouse
"  -----------------------
set mouse=a " Allow mouse scrolling
se mouse+=a

"  -----------------------
"  Line numberss
"  -----------------------
set number
set relativenumber
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

"  -----------------------
"  Colors
"  -----------------------
" Safe way to enable syntax highlighting
if !exists("g:syntax_on")
    syntax enable
endif
let python_highlight_all=1

" theme configs
" let g:solarized_termcolors=256
set background=dark
colorscheme solarized

"  -----------------------
"  Powerline
"  -----------------------
set laststatus=2 " Fix but with powerline not showing
set noshowmode
" set showtabline=2

set rtp+=/usr/local/lib/python2.7/site-packages/powerline/bindings/vim

set guifont=Hack:h14
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8

if has("gui_running")
   let s:uname = system("uname")
   if s:uname == "Darwin\n"
      set guifont=Hack
   endif
endif

"  -----------------------
"  NERDTree
"  -----------------------
" This will launch NERDTreea automatically when vim launches
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists(“s:std_in”) | NERDTree | endif
nnoremap <Leader>f :NERDTreeToggle<Enter>
nnoremap <silent> <Leader>v :NERDTreeFind<CR>

let NERDTreeQuitOnOpen = 1
let NERDTreeAutoDeleteBuffer = 1
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
" automatically close tab if the only remaining window is NERDTree
" autocmd bufenter * if (winnr(“$”) == 1 && exists(“b:NERDTreeType”) && b:NERDTreeType == “primary”) | q | endif

"  -----------------------
"  Folding / SimplyFold
"  -----------------------
set foldmethod=indent
set foldlevel=99
" Enable folding with the spacebar
nnoremap <space> za
" SimplyFold docstring preview for folded code
let g:SimpylFold_docstring_preview=1

"  -----------------------
"  Indentation
"  -----------------------
set tabstop=2
set shiftwidth=2
set expandtab

" PEP 8 indentation for python
au BufNewFile,BufRead *.py
	\ set tabstop=4 |
	\ set softtabstop=4 |
	\ set shiftwidth=4 |
	\ set textwidth=79 |
	\ set expandtab |
	\ set autoindent |
	\ set fileformat=unix

" indentation for js, html & css
au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2

"  -----------------------
"  Whitespaces
"  -----------------------

" define BadWhiteSpace first
highlight BadWhitespace ctermbg=red guibg=darkred

" Flag unneccessary whitespaces
"au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /\s\+$/

" Completor
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>\<cr>" : "\<cr>"
