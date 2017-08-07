""""""""""""""""""""""""""""""""""""""""""""""""""
" I don't really know what i'm doing...          "
""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible                " be iMproved, required!
filetype off                    " required!

" load plugins
if filereadable(expand('~/.custom.plugs'))
  source $HOME/.custom.plugs
endif

""""""""""""""""""""""""""""""""""""""""""""""""""
" Sourcing Vim Scripts and Functions             "
""""""""""""""""""""""""""""""""""""""""""""""""""

source $HOME/.vim/functions.vim

""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic Settings                                 "
""""""""""""""""""""""""""""""""""""""""""""""""""
set t_Co=256
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
set showtabline=2
set encoding=utf-8
set termencoding=utf-8
set ruler
set et
set textwidth=120
set backspace=indent,eol,start " better backspace support
set clipboard+=unnamed
set autoread
set clipboard=unnamedplus
set lazyredraw
set completeopt=menuone,longest,preview

" plugins and syntax
filetype plugin indent on
syntax on
set termguicolors
let g:deoplete#enable_at_startup = 1
let g:solarized_termcolors=256
let g:solarized_termtrans = 1
" let g:solarized_visibility = "high"
" let g:solarized_contrast = "normal"
" set background=dark
set background=light
colorscheme solarized

" set no error bells
set noerrorbells visualbell t_vb=
""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Mappings                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

" Toggle line numbers and fold column for easy copying:
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>
" Execute file being edited with <Shift> + e:
" map <buffer> <S-e> :w<CR>:!/usr/bin/env python % <CR>
" Shorter commands to toggle Taglist display
" nnoremap TT :TlistToggle<CR>
" map <F4> :TlistToggle<CR>
nmap <F4> :TagbarToggle<CR>
map <F6> :w <CR>
set pastetoggle=<F8>

map <silent> <LocalLeader>am :!make<CR>
map <silent> <LocalLeader>ac :!make clean<CR>
map <silent> <LocalLeader>au :!make upload<CR>
map <silent> <LocalLeader>aa :!make && make upload<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom Commands                                "
""""""""""""""""""""""""""""""""""""""""""""""""""

command! Pylint cexpr system('/usr/bin/env pylint --output-format=parseable --include-ids=y ' . expand('%'))

""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto Commands                                  "
""""""""""""""""""""""""""""""""""""""""""""""""""

" If your file's extention is .sh .pl. or .py
" automatically set the executable bit.
" au BufWritePost *.sh !chmod +x %
" au BufWritePost *.pl !chmod +x %
" au BufWritePost *.py !chmod +x %
" Bash style guide recommends you don't name your
" scripts .sh, so this will make your file executable
" as long as you have your shabang line as the first line.
" au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "bash" | silent !chmod +x <afile> | endif | endif

au BufRead,BufNewFile *.go set shiftwidth=4 softtabstop=4 noexpandtab
autocmd FileType html setlocal shiftwidth=2 tabstop=2 expandtab
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 expandtab

au FileType python call FT_Python()
au FileType python set omnifunc=pythoncomplete#Complete

autocmd! BufNewFile,BufRead *.pde setlocal ft=arduino
autocmd! BufNewFile,BufRead *.ino setlocal ft=arduino

" disable visual bells
autocmd GUIEnter * set visualbell t_vb=

""""""""""""""""""""""""""""""""""""""""""""""""""
" Nvim vs Vim specific configurations            "
""""""""""""""""""""""""""""""""""""""""""""""""""
if !has('nvim')
  set term=xterm-256color
endif

if has('nvim')
  autocmd BufEnter * if &buftype == "terminal" | startinsert | endif
  tnoremap <Esc> <C-\><C-n>
  command Tsplit split term://$SHELL
  command Tvsplit vsplit term://$SHELL
  command Ttabedit tabedit term://$SHELL

  let g:python_host_prog = expand('~/.pyenv/versions/neovim/bin/python')
  let g:python3_host_prog = expand('~/.pyenv/versions/neovim3/bin/python')
endif

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
" GoLang FileType Settings                       "
""""""""""""""""""""""""""""""""""""""""""""""""""
au FileType go nmap <Leader>dt <Plug>(go-def-tab)
au FileType go nmap <leader>r <Plug>(go-run)
au FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>t <Plug>(go-test)
au FileType go nmap <leader>c <Plug>(go-coverage)
au FileType go nmap <Leader>gd <Plug>(go-doc)
au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <Leader>gb <Plug>(go-doc-browser)
au FileType go nmap <Leader>s <Plug>(go-implements)
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>e <Plug>(go-rename)

let g:go_fmt_command = "goimports"
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_term_enabled = 1
let g:go_list_type = "quickfix"
let g:go_addtags_transform = "camelcase"

" let g:go_fmt_fail_silently = 1

" let g:go_fmt_autosave = 0

" let g:go_play_open_browser = 0

""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC Stuff                                     "
""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_save = 1

" Put plugins and dictionaries in this dir
let vimDir = '$HOME/.vim'
let &runtimepath.=','.vimDir

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
 let myUndoDir = expand(vimDir . '/undodir')
 " Create dirs
 call system('mkdir -p ' . myUndoDir)
 let &undodir = myUndoDir
 set undofile
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""
"" Ultisnips                                      "
"""""""""""""""""""""""""""""""""""""""""""""""""""
"" make YCM and MacVim less shitty
"if has("unix")
"  let s:uname = system("uname -s")
"  if s:uname == "Darwin"
"  " let g:ycm_path_to_python_interpreter = '/usr/bin/python2'
"  " let g:ycm_path_to_python_interpreter = '/usr/bin/env python'
"    let g:ycm_path_to_python_interpreter = '/usr/bin/python'
"  " let g:ycm_path_to_python_interpreter = '/Users/jay/.pyenv/shims/python'
"  elseif s:uname == "Linux"
"    let g:ycm_path_to_python_interpreter = '/usr/bin/env python'
"  endif
"endif
"" make YCM compatible with UltiSnips (using supertab)
"let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
"let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
"let g:SuperTabDefaultCompletionType = '<C-n>'
"let g:EclimCompletionMethod = 'omnifunc'
"
"" better key bindings for UltiSnipsExpandTrigger
"let g:UltiSnipsExpandTrigger = "<tab>"
"let g:UltiSnipsJumpForwardTrigger = "<tab>"
"let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
"" If you want :UltiSnipsEdit to split your window.
"" let g:UltiSnipsEditSplit="vertical"
