" autostart CoQ
" let g:coq_settings = { 'auto_start': v:true }

" require our lua plugins script
lua require('bootstrap').run_paq()
lua require('init')
