" Font
set guifont=Inconsolata\ 12

" No audible bell
set vb

" No toolbar
set guioptions-=T
" set guioptions=egmrt

" autocmd VimEnter * NERDTree
autocmd VimEnter * NERDTreeFind
autocmd VimEnter * wincmd p
autocmd BufEnter * lcd %:p:h
" map <leader>r :NERDTreeFind<cr>

set lines=40 columns=140
:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>
