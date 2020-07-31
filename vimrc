if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug '/usr/local/opt/fzf'
Plug 'airblade/vim-gitgutter'
Plug 'aliou/sql-heredoc.vim'
Plug 'bioSyntax/bioSyntax-vim'
Plug 'gregsexton/MatchTag'
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'machakann/vim-highlightedyank'
Plug 'mattn/emmet-vim'
Plug 'morhetz/gruvbox'
Plug 'sheerun/vim-polyglot'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-rails'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
call plug#end()

set t_ut=
set background=dark
set clipboard=unnamed
set cursorline
set encoding=UTF-8
set expandtab
set hlsearch
set ignorecase smartcase
set list
set noswapfile
set number relativenumber
set shortmess=I
set tabstop=2 shiftwidth=2 expandtab

" don't use the arrow keys!
nnoremap <Up>    <Nop>
nnoremap <Down>  <Nop>
nnoremap <Left>  <Nop>
nnoremap <Right> <Nop>

" This unsets the 'last search pattern' register by hitting return
nnoremap <CR> :noh<CR><CR>

" airline
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1

" Fzf
nnoremap <leader><leader> :GFiles<CR>
nnoremap <leader><CR>     :Buffers<CR>

" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Gruvbox
let g:gruvbox_bold      = 1
let g:gruvbox_undercurl = 1
let g:gruvbox_italic    = 1
let g:gruvbox_underline = 1
let g:gruvbox_inverse   = 1

augroup gruvbox-overrides
  autocmd!
  autocmd ColorScheme gruvbox highlight htmlArg cterm=italic gui=italic ctermfg=214 guifg=#fabd2f
  autocmd ColorScheme gruvbox highlight xmlAttrib cterm=italic gui=italic ctermfg=214 guifg=#fabd2f
  autocmd ColorScheme gruvbox highlight jsxAttrib cterm=italic gui=italic ctermfg=214 guifg=#fabd2f
augroup END

colorscheme gruvbox
