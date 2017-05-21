"---------- Font ----------"
if has("win32")
"	set guifont=Ubuntu_Mono_derivative_Powerlin:h11:cANSI:qDRAFT
	set  guifont=DejaVu_Sans_Mono_for_Powerline:h11:cANSI:qDRAFT
endif
"---------- Colorscheme ----------"
if has("win32")
	colorscheme solarized
"let g:solarized_termcolors = 256
endif

syntax on
set relativenumber
set laststatus=2
scriptencoding utf-8
set encoding=utf-8
set termencoding=utf-8
set fileencoding=utf-8
set list listchars=tab:»\ ,eol:¬,nbsp:˽,trail:•,extends:›,precedes:‹
set t_Co=256
set background=dark
