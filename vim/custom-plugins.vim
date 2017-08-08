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
Plug 'altercation/vim-colors-solarized'

""" syntax & linting
Plug 'FooSoft/vim-argwrap' " arg (de)wrapping
Plug 'w0rp/ale' " lint
Plug 'junegunn/vim-easy-align' " code alignment

"" Lang Specific

" GoLang
Plug 'fatih/vim-go'
Plug 'godoctor/godoctor.vim'

" Markdown
Plug 'gabrielelana/vim-markdown'

" Java
Plug 'artur-shaik/vim-javacomplete2'

" Initialize plugin system
call plug#end()
