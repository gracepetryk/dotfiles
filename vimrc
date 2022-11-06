call plug#begin()
Plug 'easymotion/vim-easymotion'
Plug 'vim-airline/vim-airline'
call plug#end()

syntax on

set tabstop=2 expandtab shiftwidth=2 smarttab
set number relativenumber

set scrolloff=10

map s <Plug>(easymotion-bd-w)
map <S-w> <Plug>(easymotion-w)
map <S-b> <Plug>(easymotion-b)
map <S-j> <Plug>(easymotion-j)
map <S-k> <Plug>(easymotion-k)

nnoremap i a
nnoremap a i
nnoremap x "_x
imap jj <Esc>

