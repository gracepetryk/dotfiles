syntax on

set tabstop=2 expandtab shiftwidth=2 smarttab
set number relativenumber

set scrolloff=10

let g:AutoPairs = { '<?': '?>//k]' }

call plug#begin()

Plug 'gracepetryk/auto-pairs', { 'branch': 'expr-maps' }

call plug#end()
