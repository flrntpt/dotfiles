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

" Config
set timeoutlen=1000 ttimeoutlen=0" Fix bug with backspace " Remove timeout
set backspace=indent,eol,start " Fix bug
set clipboard=unnamed
set laststatus=2 " Fix but with powerline not showing

"  -----------------------
"  Mouse
"  -----------------------
set mouse=a " Allow mouse scrolling
se mouse+=a

"  -----------------------
"  Colors
"  -----------------------
syntax on " Syntax highlighting 
color desert " Colorscheme
set number
set relativenumber
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE

" theme configs
" " let g:solarized_termcolors=256
" " set background=dark
set background=dark
colorscheme solarized

" setting for vim-visual-page-percent
set statusline+=%{VisualPercent()}
set statusline=%<\ %n:%F\ %m%r%y%=%-35.(L:\ %l\ /\ %L,\ C:\ %c%V\ (%P)%)
set hls


"  -----------------------
"  Command line
"  -----------------------
set guifont=SourceCodePro\ for\ Powerline:h15
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8


" Mac OS X clipboard integration
nmap <F1> :set paste<CR>:r !pbpaste<CR>:set nopaste<CR>
vmap <F2> :w !pbcopy<CR><CR

set rtp+=/usr/local/lib/python2.7/site-packages/powerline/bindings/vim
