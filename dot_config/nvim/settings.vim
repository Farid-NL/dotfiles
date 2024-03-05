" GENERAL
set number                              " Line numbers
set cursorline                          " Enable highlighting of the current line
set encoding=utf-8                      " The encoding displayed
set fileencoding=utf-8                  " The encoding written to file
" set ruler                             " Show the cursor position all the time
set splitbelow                          " Horizontal splits will automatically be below
set splitright                          " Vertical splits will automatically be to the right
set conceallevel=0                      " So that I can see `` in markdown files
" set showtabline=2                       " Always show tabs
set noshowmode                          " We don't need to see things like -- INSERT -- anymore
set background=dark                     " tell vim what the background color looks like
let asmsyntax='tasm'                    " Syntax highlighting for .asm files with NASM, MASM or TASM

" set formatoptions-=cro                " Stop newline continution of comments
set clipboard=unnamedplus               " Copy paste between vim and everything else

" INDENTATION
set tabstop=4                           " Insert 4 spaces for a tab
set shiftwidth=4                        " Change the number of space characters inserted for indentation
set smarttab                            " Makes tabbing smarter will realize you have 2 vs 4
set expandtab                           " Converts tabs to spaces
set smartindent                         " Makes indenting smart
set autoindent                          " Good auto indent

" SEARCHING
set smartcase                           " Enable smart-case search
set ignorecase                          " Always case-insensitive
