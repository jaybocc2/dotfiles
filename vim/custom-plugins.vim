" Specify a directory for plugins
" - Avoid using standard Vim directory name like 'plugin'
call plug#begin('~/.vim/plugged')

"" " code completion
"" if has('nvim')
""   Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
""   " Plug 'carlitux/deoplete-ternjs', { 'do': 'NODENV_VERSION=6.11.2 npm install -g tern' }
"" 
""   " Python
""   Plug 'deoplete-plugins/deoplete-jedi'
""   " GoLang
""   Plug 'deoplete-plugins/deoplete-go', { 'do': 'make'}
""   " Ruby
""   Plug 'jaybocc2/deoplete-ruby', { 'branch': 'fix-deoplete-import' }
""   " Make
""   " Plug 'deoplete-plugins/deoplete-make'
""   " Docker
""   Plug 'jaybocc2/deoplete-docker', { 'branch': 'fix-deoplete-import' }
"" endif
"" 
"" if !has('nvim')
""   Plug 'Valloric/YouCompleteMe', { 'do': 'PYEN_VERSION=27global python ./install.py --gocode-completer --tern-completer' }
"" endif

" auto close paren / quote
Plug 'cohama/lexima.vim'

" Make it easier to find the cursor after searching
Plug 'inside/vim-search-pulse'

" Edit surrounding quotes / parents / etc
" - {Visual}S<arg> surrounds selection
" - cs/ds<arg1><arg2> change / delete
" - ys<obj><arg> surrounds text object
" - yss<arg> for entire line
Plug 'tpope/vim-surround'

" Adds helpers for UNIX shell commands
" :Remove Delete buffer and file at same time
" :Unlink Delete file, keep buffer
" :Move Rename buffer and file
Plug 'tpope/vim-eunuch'

" CoC (Language Server stuff)
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" Syntax highlighting for a ton of languages
Plug 'sheerun/vim-polyglot'

" Colorschemes {{{
Plug 'freeo/vim-kalisi'
Plug 'josuegaleas/jay'
Plug 'morhetz/gruvbox'
Plug 'rakr/vim-one'
Plug 'joshdick/onedark.vim'
Plug 'jonathanfilip/vim-lucius'
if has('nvim')
  Plug 'frankier/neovim-colors-solarized-truecolor-only'
else
  Plug 'altercation/vim-colors-solarized'
endif
" }}}

" vim-gutter - git diff highlights
Plug 'airblade/vim-gitgutter'

" statusbar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" airline generator
Plug 'edkolev/promptline.vim'
Plug 'edkolev/tmuxline.vim'

""" syntax & linting
Plug 'FooSoft/vim-argwrap' " arg (de)wrapping
Plug 'dense-analysis/ale' " lint
Plug 'junegunn/vim-easy-align' " code alignment
Plug 'majutsushi/tagbar' " tag bar
Plug 'scrooloose/nerdtree' " tree explorer
Plug 'nathanaelkane/vim-indent-guides' " indent guides
Plug 'hashivim/vim-terraform' " vim TF formatting/style
Plug 'tmhedberg/SimpylFold' " python folding

"" Lang Specific

" GoLang

" Markdown

" Java

" JavaScript

" Edit config
Plug 'editorconfig/editorconfig-vim'


" Initialize plugin system
call plug#end()
