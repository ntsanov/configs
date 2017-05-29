"---------- Font ----------"
if has("win32")
"	set guifont=Ubuntu_Mono_derivative_Powerlin:h11:cANSI:qDRAFT
	set  guifont=DejaVu_Sans_Mono_for_Powerline:h10:cANSI:qDRAFT
else
	set guifont=DejaVu\ Sans\ Mono\ for\ Powerline
endif
syntax on
set relativenumber
set laststatus=2
set tabstop=4
set cursorline
scriptencoding utf-8
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set list listchars=tab:»\ ,eol:¬,nbsp:˽,trail:•,extends:›,precedes:‹
"--Persistent undo
"Folders ~/.vim/undo or vimfiles/undo MUST EXIST
if has("win32")
	set undofile
	set undodir='%USERPROFILE%/vimfiles/undo'
	set undolevels=1000
	set undoreload=10000
else
	set undofile                " Save undo's after file closes
	set undodir=$HOME/.vim/undo " where to save undo histories
	set undolevels=1000         " How many undos
	set undoreload=10000        " number of lines to save for undo
endif

"
"--Plugin Airline--
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1

"--Plugin CtrlP --
let g:ctrlp_working_path_mode = 'c'
let g:ctrlp_cache_dir = $HOME . '/.vim/cache/ctrlp'
