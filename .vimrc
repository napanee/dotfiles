call plug#begin(expand('~/.vim/plugged'))

" Tagline/Statusbar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Syntax Theme
Plug 'tomasiser/vim-code-dark'

call plug#end()

"" Status bar
set laststatus=2

" Syntax Theme
colorscheme codedark

" vim-airline >
let g:airline_theme = 'murmur'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

let g:airline#extensions#tabline#left_sep = '▓▒░'
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline_left_sep = '▓▒░'
let g:airline_left_alt_sep = ''
let g:airline_right_sep = '░▒▓'
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ' '
let g:airline_symbols.colnr = ':'
let g:airline_symbols.maxlinenr = ''


"*****************************************************************************
"" Visual Settings
"*****************************************************************************
set tabstop=4 softtabstop=4 shiftwidth=4
set list listchars=tab:\ ,trail:·,extends:»,precedes:«,nbsp:×
set relativenumber
