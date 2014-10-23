""""""""""""""""""""""""""""""""""""""""""""""""""
" I don't really know what i'm doing...          "
""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                " be iMproved
filetype off                    " required!

""""""""""""""""""""""""""""""""""""""""""""""""""
" Sourcing Vim Scripts and Functions             "
""""""""""""""""""""""""""""""""""""""""""""""""""

source $HOME/.vim/functions.vim

""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic Settings                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""
set autoread
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab
set tabstop=2
set shortmess=I
set hlsearch
set showmatch
set incsearch
set number
" A nice status line that looks like this:
" ~/www/.vimrc[+][47][unix][vim][34%][0016,0001]
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
" keeps a permanent blank line for commands and
" keeps the status bar always visible
set laststatus=2
set ruler
set et
set textwidth=80
set backspace=indent,eol,start " better backspace support
set clipboard+=unnamed
set autoread
set clipboard=unnamedplus
set lazyredraw
set completeopt=menuone,longest,preview
" plugins and syntax
filetype plugin on
filetype indent on
syntax on
set background=dark
colorscheme solarized

" enable 80 and 120 character colums
" set colorcolumn=+1
" highlight ColorColumn ctermbg=235 guibg=#2c2d27
" let &colorcolumn="80,".join(range(120,999),",")

" set no error bells
set noerrorbells visualbell t_vb=
""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Mappings                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

" Toggle line numbers and fold column for easy copying:
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
" Execute file being edited with <Shift> + e:
map <buffer> <S-e> :w<CR>:!/usr/bin/env python % <CR>
" Shorter commands to toggle Taglist display
nnoremap TT :TlistToggle<CR>
map <F4> :TlistToggle<CR>
map <F5> :silent !touch ~/code/{mc_cp,edb}/django.wsgi <CR>
map <F6> :w <CR>
set pastetoggle=<F8>

map <silent> <LocalLeader>am :!make<CR>
map <silent> <LocalLeader>ac :!make clean<CR>
map <silent> <LocalLeader>au :!make upload<CR>
map <silent> <LocalLeader>aa :!make && make upload<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Commands                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

command! Pylint cexpr system('/usr/bin/pylint --output-format=parseable --include-ids=y ' . expand('%'))

""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto Commands                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""

" If your file's extention is .sh .pl. or .py
" automatically set the executable bit.
au BufWritePost *.sh !chmod +x %
au BufWritePost *.pl !chmod +x %
au BufWritePost *.py !chmod +x %
" Bash style guide recommends you don't name your
" scripts .sh, so this will make your file executable
" as long as you have your shabang line as the first line.
" au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "bash" | silent !chmod +x <afile> | endif | endif

au BufRead,BufNewFile *.go set shiftwidth=4 softtabstop=4 noexpandtab
au FileType ruby set shiftwidth=2 softtabstop=2 tabstop=2

au FileType python call FT_Python()
au FileType python set omnifunc=pythoncomplete#Complete

autocmd! BufNewFile,BufRead *.pde setlocal ft=arduino
autocmd! BufNewFile,BufRead *.ino setlocal ft=arduino

" disable visual bells
autocmd GUIEnter * set visualbell t_vb=
""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto Load File Templates                       "
""""""""""""""""""""""""""""""""""""""""""""""""""

au BufNewFile *.py r $HOME/.vim/templates/skeleton.py

""""""""""""""""""""""""""""""""""""""""""""""""""
" Python FileType Settings                       "
""""""""""""""""""""""""""""""""""""""""""""""""""

function! FT_Python()
  " Indent Python in the Google way.
  setlocal indentexpr=GetGooglePythonIndent(v:lnum)

  let s:maxoff = 50 " maximum number of lines to look backwards.
  let pyindent_nested_paren="&sw*2"
  let pyindent_open_paren="&sw*2"

  map <buffer> <Leader>p8 :call Pep8()<CR>
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""
" JSON FileType Settings                         "
""""""""""""""""""""""""""""""""""""""""""""""""""
au! BufRead,BufNewFile *.json set filetype=json
" autocmd BufNewFile,BufRead *.json set ft=javascript
"let g:vim_json_syntax_conceal = 0

""""""""""""""""""""""""""""""""""""""""""""""""""
" Powershell FileType Settings                   "
""""""""""""""""""""""""""""""""""""""""""""""""""

au BufNewFile,BufRead   *.ps1xml   set ft=ps1xml
au BufNewFile,BufRead   *.ps1   set ft=ps1
au BufNewFile,BufRead   *.psd1  set ft=ps1
au BufNewFile,BufRead   *.psm1  set ft=ps1

""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC Stuff                                     "
""""""""""""""""""""""""""""""""""""""""""""""""""

" Taglist variables
" Display function name in status bar:
let g:ctags_statusline=1
" Automatically start script
let generate_tags=1
" Displays taglist results in a vertical window:
let Tlist_Use_Horiz_Window=0
" Various Taglist diplay config:
let Tlist_Use_Right_Window = 1
let Tlist_Compact_Format = 1

let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_File_Fold_Auto_Close = 1

" tab completion for python
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabClosePreviewOnPopupClose = 1
