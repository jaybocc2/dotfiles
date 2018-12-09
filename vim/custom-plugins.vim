" Specify a directory for plugins
" - Avoid using standard Vim directory name like 'plugin'
call plug#begin('~/.vim/plugged')

" code completion
if has('nvim')
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  " Plug 'carlitux/deoplete-ternjs', { 'do': 'NODENV_VERSION=6.11.2 npm install -g tern' }
  Plug 'zchee/deoplete-go', { 'do': 'make'}
  Plug 'fishbullet/deoplete-ruby'
  Plug 'zchee/deoplete-jedi'
endif

if !has('nvim')
  Plug 'Valloric/YouCompleteMe', { 'do': 'PYEN_VERSION=27global python ./install.py --gocode-completer --tern-completer' }
endif

" Colors
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

" statusbar
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" airline generator
Plug 'edkolev/promptline.vim'
Plug 'edkolev/tmuxline.vim'

""" syntax & linting
Plug 'FooSoft/vim-argwrap' " arg (de)wrapping
Plug 'w0rp/ale' " lint
Plug 'junegunn/vim-easy-align' " code alignment
Plug 'majutsushi/tagbar' " tag bar
Plug 'scrooloose/nerdtree' " tree explorer
Plug 'nathanaelkane/vim-indent-guides' " indent guides
Plug 'hashivim/vim-terraform' " vim TF formatting/style

"" Lang Specific

" GoLang
Plug 'fatih/vim-go'
Plug 'godoctor/godoctor.vim'

" Markdown
Plug 'gabrielelana/vim-markdown'

" Java
Plug 'artur-shaik/vim-javacomplete2'

" JavaScript
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'mattn/emmet-vim'

" Edit config
Plug 'editorconfig/editorconfig-vim'


" Initialize plugin system
call plug#end()
