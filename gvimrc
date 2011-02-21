" Font
set guifont=Consolas:h10.00

" No audible bell
set vb

" No toolbar
set guioptions-=T

autocmd VimEnter * NERDTree
autocmd VimEnter * wincmd p

set lines=40 columns=140
:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>

