call plug#begin()
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
call plug#end()

syntax on

set tabstop=2 expandtab shiftwidth=2 smarttab
set number relativenumber

set scrolloff=10

nnoremap x "_x
imap jj <Esc>
imap ;; <Right>
imap hh <Left>
nnoremap d "_d
nnoremap DD dd
nnoremap D d

" method args macro
:let @s = "i\njjf,w@s"
:let @a = "f(l@sf)i\n<BS>jjw"
