set nocompatible              " be iMproved, required
filetype off                  " required
set mouse=a

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}


Plugin 'JuliaEditorSupport/julia-vim'

Plugin 'jiangmiao/auto-pairs'

Plugin 'preservim/nerdtree'

Plugin 'vim-airline/vim-airline'

Plugin 'Lattay/vasp.vim'

Plugin 'jistr/vim-nerdtree-tabs'

Plugin 'vim-airline/vim-airline-themes'

Plugin 'SirVer/ultisnips'

Plugin 'rafi/awesome-vim-colorschemes' 

" Plugin 'dkarter/bullets.vim'

" Plugin 'vim-scripts/Conque-Shell'

" Plugin 'miyakogi/conoline.vim'

" Plugin 'rkulla/pydiction'

" Plugin 'SirVer/ultisnips'

" Plugin 'honza/vim-snippets'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


" To ignore plugin indent changes, instead use:
"Filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"colo desert    " Color scheme that works well in visual model
colo deus
syntax on


set number

set softtabstop=4 shiftwidth=4 expandtab

autocmd VimEnter * NERDTree
autocmd VimEnter * NERDTreeTabsOpen
autocmd VimEnter * wincmd p

" Make the cursor move to the next line/the previous line 
" when it arrives at the end/the initial of this line
set whichwrap+=<,>,h,l,[,]

" Use up and down keys to move between 
" lines in a soft-wrapped physical line
nnoremap <expr> <Up>  (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> <Down> (v:count == 0 ? 'gj' : 'j')

" Configurations for airline
" @airline
set t_Co=256 "Seems required for correct color display with Xshell
let g:airline#extensions#tabline#enabled = 1   " opening tabline
"let g:airline_powerline_fonts = 1
set laststatus=2  " always display status line
let g:airline_theme='bubblegum' " theme
"let g:airline#extensions#tabline#left_sep = ' '  "separater
"let g:airline#extensions#tabline#left_alt_sep = '|'  "separater
"let g:airline#extensions#tabline#formatter = 'default'  "formater
"let g:airline_left_sep = '▶'
"let g:airline_left_alt_sep = '❯'
"let g:airline_right_sep = '◀'
"let g:airline_right_alt_sep = '❮'"
let g:airline#extensions#tabline#fnamemod = ':.'
let g:airline#extensions#tabline#fnamecollapse = 0
let g:airline#extensions#tabline#fnamemod = ':t' " Show file name only in tabs


" Configurations for code snippets
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"

" Highlighting the current line
"let g:conoline_color_normal_dark = 'guibg=#333333 guifg=#dddddd gui=None '
"                          \. 'ctermbg=black ctermfg=white'
"let g:conoline_color_insert_dark = 'guibg=black guifg=white gui=bold '
"                           \. 'ctermbg=grey ctermfg=white'
set cursorline
"hi CursorLine ctermbg=18 term=none cterm=none
"hi CursorLine   cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE

