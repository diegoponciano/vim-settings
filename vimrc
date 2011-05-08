"Use Vim settings, rather then Vi settings (much better!).
"This must be first, because it changes other options as a side effect.
set nocompatible

"allow backspacing over everything in insert mode
set backspace=indent,eol,start

"store lots of :cmdline history
set history=1000
colorscheme wombat
set showcmd     "show incomplete cmds down the bottom
set showmode    "show current mode down the bottom

set incsearch   "find the next match as we type the search
set hlsearch    "hilight searches by default

" set nowrap      "dont wrap lines
" set linebreak   "wrap lines at convenient points

"makes vim works with RVM
set shellcmdflag=-ic

"statusline setup
set statusline=%f       "tail of the filename

"line numbers
set number
set pastetoggle=<F5>

"display a warning if fileformat isnt unix
set statusline+=%#warningmsg#
set statusline+=%{&ff!='unix'?'['.&ff.']':''}
set statusline+=%*

"display a warning if file encoding isnt utf-8
set statusline+=%#warningmsg#
set statusline+=%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.']':''}
set statusline+=%*

set statusline+=%h      "help file flag
set statusline+=%y      "filetype
set statusline+=%r      "read only flag
set statusline+=%m      "modified flag

"display a warning if &et is wrong, or we have mixed-indenting
set statusline+=%#error#
set statusline+=%{StatuslineTabWarning()}
set statusline+=%*

set statusline+=%{StatuslineTrailingSpaceWarning()}

set statusline+=%{StatuslineLongLineWarning()}

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"display a warning if &paste is set
set statusline+=%#error#
set statusline+=%{&paste?'[paste]':''}
set statusline+=%*

set statusline+=%=      "left/right separator
set statusline+=%{StatuslineCurrentHighlight()}\ \ "current highlight
set statusline+=%c,     "cursor column
set statusline+=%l/%L   "cursor line/total lines
set statusline+=\ %P    "percent through file
set laststatus=2

"recalculate the trailing whitespace warning when idle, and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_trailing_space_warning

"return '[\s]' if trailing white space is detected
"return '' otherwise
function! StatuslineTrailingSpaceWarning()
    if !exists("b:statusline_trailing_space_warning")
        if search('\s\+$', 'nw') != 0
            let b:statusline_trailing_space_warning = '[\s]'
        else
            let b:statusline_trailing_space_warning = ''
        endif
    endif
    return b:statusline_trailing_space_warning
endfunction


"return the syntax highlight group under the cursor ''
function! StatuslineCurrentHighlight()
    let name = synIDattr(synID(line('.'),col('.'),1),'name')
    if name == ''
        return ''
    else
        return '[' . name . ']'
    endif
endfunction

"recalculate the tab warning flag when idle and after writing
autocmd cursorhold,bufwritepost * unlet! b:statusline_tab_warning

"return '[&et]' if &et is set wrong
"return '[mixed-indenting]' if spaces and tabs are used to indent
"return an empty string if everything is fine
function! StatuslineTabWarning()
    if !exists("b:statusline_tab_warning")
        let tabs = search('^\t', 'nw') != 0
        let spaces = search('^ ', 'nw') != 0

        if tabs && spaces
            let b:statusline_tab_warning =  '[mixed-indenting]'
        elseif (spaces && !&et) || (tabs && &et)
            let b:statusline_tab_warning = '[&et]'
        else
            let b:statusline_tab_warning = ''
        endif
    endif
    return b:statusline_tab_warning
endfunction

"recalculate the long line warning when idle and after saving
autocmd cursorhold,bufwritepost * unlet! b:statusline_long_line_warning

"return a warning for "long lines" where "long" is either &textwidth or 80 (if
"no &textwidth is set)
"
"return '' if no long lines
"return '[#x,my,$z] if long lines are found, were x is the number of long
"lines, y is the median length of the long lines and z is the length of the
"longest line
function! StatuslineLongLineWarning()
    if !exists("b:statusline_long_line_warning")
        let long_line_lens = s:LongLines()

        if len(long_line_lens) > 0
            let b:statusline_long_line_warning = "[" .
                        \ '#' . len(long_line_lens) . "," .
                        \ 'm' . s:Median(long_line_lens) . "," .
                        \ '$' . max(long_line_lens) . "]"
        else
            let b:statusline_long_line_warning = ""
        endif
    endif
    return b:statusline_long_line_warning
endfunction

"return a list containing the lengths of the long lines in this buffer
function! s:LongLines()
    let threshold = (&tw ? &tw : 80)
    let spaces = repeat(" ", &ts)

    let long_line_lens = []

    let i = 1
    while i <= line("$")
        let len = strlen(substitute(getline(i), '\t', spaces, 'g'))
        if len > threshold
            call add(long_line_lens, len)
        endif
        let i += 1
    endwhile

    return long_line_lens
endfunction

"find the median of the given array of numbers
function! s:Median(nums)
    let nums = sort(a:nums)
    let l = len(nums)

    if l % 2 == 1
        let i = (l-1) / 2
        return nums[i]
    else
        return (nums[l/2] + nums[(l/2)-1]) / 2
    endif
endfunction

"indent settings
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=3       "deepest fold is 3 levels
set nofoldenable        "dont fold by default

set wildmode=list:longest   "make cmdline tab completion similar to bash
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing


set formatoptions-=o "dont continue comments when pushing o/O

"vertical/horizontal scroll off settings
set scrolloff=3
set sidescrolloff=7
set sidescroll=1

"load ftplugins and indent files
filetype plugin on
filetype indent on

"turn on syntax highlighting
syntax on

"some stuff to get the mouse going in term
set mouse=a
set ttymouse=xterm2

"tell the term has 256 colors
set t_Co=256

"hide buffers when not displayed
set hidden

"dont load csapprox if we no gui support - silences an annoying warning
if !has("gui")
    let g:CSApprox_loaded = 1
endif

command Txml set ft=xml | execute "%!tidy -q -i -xml"
command Thtml set ft=html | execute "%!tidy -q -i -html"

" tidy html
map <F12> :%!tidy -i -q --tidy-mark 0 2>/dev/null<CR>

" Shift+Alt+r replaces current word
nnoremap <s-m-r> :%s/<C-r><C-w>//gc<Left><Left><Left>
inoremap <s-m-r> <C-O>:%s/<C-r><C-w>//g<Left><Left>
vnoremap <s-m-r> "hy:%s/<C-r>h//gc<Left><Left><Left>

"Basically you press <m-s> to search for the current selection !! Really useful
vnoremap <silent> <s-s> :call VisualSearch('f')<CR>
inoremap <silent> <s-s> <c-o>/<C-r><c-w>/e<CR>
noremap <silent> <s-s> /<c-r><c-w>/e<CR>

"Basically you press <m-r> to search for the current selection !! Really useful
vnoremap <silent> <m-r> :call VisualSearch('b')<CR>
inoremap <silent> <m-r> <c-o>?<C-r><c-w><CR>
nnoremap <silent> <m-r> ?<C-r><c-w><CR>

" Copy paste using system clipboard
vmap <C-y> "+y
vmap <C-u> "+p
nmap <C-u> "+p
imap <C-u> <esc>"+p
imap <C-v> <esc>pa

" CTRL-S is Save
noremap <C-s> :w<CR>
inoremap <C-s> <esc>:w<CR>

" Ctrl-A == Select All
nmap <silent> <C-A> ggVG<CR>
    
"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

" ,bd to close buffer without changing window layout.
nmap <leader>bd :Bclose<CR>
imap <C-b>d <esc>:Bclose<CR>

" new line after the cursor (move content to the new line)
nnoremap <C-J> a<CR><Esc>k$

" Enter to new line after, Shift-Enter to new line before
map <S-Enter> O<Esc>
" map <CR> o<Esc>
nmap <CR> o<Esc>

"map O O<Esc>j
"map o o<Esc>k

"map to bufexplorer
nnoremap <C-B> :BufExplorer<cr>

"map to fuzzy finder text mate stylez
nnoremap <c-f> :FuzzyFinderTextMate<CR>

"map Q to something useful
noremap Q gq

"make Y consistent with C and D
nnoremap Y y$

"mark syntax errors with :signs
let g:syntastic_enable_signs=1

" enables tree style on netrw
let g:netrw_liststyle=3

"visual search mappings
function! s:VSetSearch()
    let temp = @@
    norm! gvy
    let @/ = '\V' . substitute(escape(@@, '\'), '\n', '\\n', 'g')
    let @@ = temp
endfunction
vnoremap * :<C-u>call <SID>VSetSearch()<CR>//<CR>
vnoremap # :<C-u>call <SID>VSetSearch()<CR>??<CR>


"jump to last cursor position when opening a file
"dont do it when writing a commit log entry
autocmd BufReadPost * call SetCursorPosition()
function! SetCursorPosition()
    if &filetype !~ 'commit\c'
        if line("'\"") > 0 && line("'\"") <= line("$")
            exe "normal! g`\""
            normal! zz
        endif
    end
endfunction

"define :HighlightLongLines command to highlight the offending parts of
"lines that are longer than the specified length (defaulting to 80)
command! -nargs=? HighlightLongLines call s:HighlightLongLines('<args>')
function! s:HighlightLongLines(width)
    let targetWidth = a:width != '' ? a:width : 79
    if targetWidth > 0
        exec 'match Todo /\%>' . (targetWidth) . 'v/'
    else
        echomsg "Usage: HighlightLongLines [natural number]"
    endif
endfunction

if has('gui running')
  set guifont=Consolas:h9
endif

map <F2> :NERDTreeToggle<CR>

set nobackup
set nowritebackup
set noswapfile

" Setup Vundle Support {
" The next two lines ensure that the ~/.vim/vundle.git system works
    set rtp+=~/.vim/vundle.git/
    silent! call vundle#rc()

    " original repos on github
    " preview markup files (markdown,rdoc,textile,html)
    Bundle 'greyblake/vim-preview'
    " tab autocomplete
    Bundle "ervandew/supertab"
    " snippets for snipMate
    Bundle "scrooloose/snipmate-snippets"
    " The-NERD-tree
    Bundle "scrooloose/nerdtree"
    " Mini-BufExplorer
    Bundle "fholgado/minibufexpl.vim"
    " Rails
    Bundle "tpope/vim-rails"

    " default repository
    " MatchIt
    Bundle "matchit.zip" 
    " Ruby MatchIt
    Bundle "ruby-matchit" 
    " BufExplorer
    Bundle "bufexplorer"  
    " Commant-T
    Bundle "command-T"
    " snippets
    Bundle "snipMate"
    " better comments
    Bundle "The-NERD-Commenter"
    " git goodness
    Bundle "fugitive.vim"
    " delimiters
    Bundle "delimitMate.vim"
    " surround with parentheses, brackets, quotes
    Bundle "surround.vim"
    " file explorer
    "Bundle The-NERD-tree"
    " better grep
    Bundle "ack.vim"
    " json support
    Bundle "JSON.vim"
    " better jquery syntax
    Bundle "jQuery"
    if has('gui')
      " use themes in console
      Bundle "CSApprox"
    endif
    " bunch of themes"
    Bundle "Color-Sampler-Pack"
    " changes colors easily
    Bundle "ScrollColors"
    " save sessions
    Bundle "session.vim--Odding"
    " L9
    Bundle "L9"
    " finding files
    Bundle "FuzzyFinder"
    " }

