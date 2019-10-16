execute pathogen#infect()
syntax on
filetype plugin indent on

set nocompatible
set number
set ruler
set ignorecase
set showcmd
""set showmatch
set history=1000
set cursorline
set cursorcolumn
""highlight CursorLine   cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
""highlight CursorColumn cterm=NONE ctermbg=black ctermfg=green guibg=NONE guifg=NONE
set guioptions-=m
set guioptions-=T
set clipboard+=unnamed 
set completeopt=longest,menu
syntax enable
syntax on
set number
set noswapfile
set background=dark
colorscheme solarized
set tabpagemax=50
inoremap ( ()<LEFT>
inoremap [ []<LEFT>
inoremap { {}<LEFT>
inoremap " ""<LEFT>
""inoremap ' ''<LEFT>
""inoremap < <><LEFT>
set splitright                  " 新分割窗口在右边
set splitbelow                  " 新分割窗口在下边
"status line"
au VimResized * exe "normal! \<c-w>="
set laststatus=2 
""set statusline=%F%m%r%h%w\[TYPE=%Y]\ [%p%%]
""set statusline=%F%m%r%h%w\[FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%04l,%04v][%p%%]\ [%L]
set statusline=%2*%n%m%r%h%w%*\ %F\ [COL=%2*%03v%1*]\ [ROW=%2*%03l%1*/%3*%L(%p%%)%1*]\
""set statusline=%2*%n%m%r%h%w%*\ %F\ %1*[FORMAT=%2*%{&ff}:%{&fenc!=''?&fenc:&enc}%1*]\ [TYPE=%2*%Y%1*]\ [COL=%2*%03v%1*]\ [ROW=%2*%03l%1*/%3*%L(%p%%)%1*]\
""hi User1 guifg=gray
""hi User2 guifg=red
""hi User3 guifg=white
"5. 设置缩进"
"============="
set cindent "c/c++自动缩进"
set smartindent
set autoindent"参考上一行的缩进方式进行自动缩进"
filetype indent on "根据文件类型进行缩进"
""set foldmethod=indent

set tabstop=4
set softtabstop=4
set shiftwidth=4
""set expandtab
""autocmd FileType make set noexpandtab
""au FileType sv set tabstop=2
set autoread"文件在Vim之外修改过，自动重新读入"
"--------------------------------taglist-------------------------------------------------"
"ctags"
let Tlist_Show_One_File = 1            "不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow = 1          "如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Use_Right_Window = 1         "在右侧窗口中显示taglist窗口 
let g:Tlist_Ctags_Cmd='/usr/bin/ctags'
""-------------------------------------------------------------------------------"""""
"-------------------------------------tagbar------------------------------------------"
""let g:tagbar_width=35
""let g:tagbar_autofocus=1
""let g:tagbar_left = 1
""nmap <F3> :TagbarToggle<CR>
""let g:tagbar_ctags_bin='/usr/bin/ctags'
"""-------------------------------------------------------------------------------"

set wrap ""设置自动折行,把长的一行用多行显示
set linebreak
set nolist
set textwidth=0
set wrapmargin=0
""set nowrap 设置不自动折行
""set guifont=Courier\ 12
set hlsearch
set nocompatible
set backspace=indent,eol,start
""------------------------vim-plug-----------------------
""call plug#begin('~/.vim/plugged')
""""Plug 'https://github.com/mhinz/vim-startify'
""""Plug 'junegunn/seoul256.vim'
""""Plug 'junegunn/goyo.vim'
""""Plug 'junegunn/limelight.vim'
""call plug#end()
set guitablabel=\[%N\]\ %t\ %M "使用命令[Number] gt立即切换到所选选项卡"
