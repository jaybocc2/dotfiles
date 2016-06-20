" set .py and .sls files to be ft python
au BufNewFile,BufRead *.py,*.sls  set filetype=python
" set tabstops vim python
autocmd FileType python setlocal shiftwidth=4 softtabstop=4 tabstop=4 expandtab
