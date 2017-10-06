set nocompatible

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif

" Make compatible with dark terminal
set background=dark

filetype plugin indent on
syntax on

"tab options
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set smartindent
set autoindent

"search options
set hlsearch
set incsearch
set ignorecase
set smartcase
set nowrapscan

"backup/swp options
set backup
set backupdir=~/.vim/tmp//
set dir=~/.vim/.swp//
set history=200
set undofile
set undodir=~/.vim/.undo//

"usability
set bs=indent,eol,start
set ruler
set number
set mouse=a
set scrolloff=10
set cursorline
set autoread
set showcmd

"split options
set splitbelow
set splitright

"autocomplete act like bash
set wildmenu
set wildmode=longest,list

"hit <enter> to clear search highlight
nnoremap <CR> :noh<CR><CR>

"add </> brackets to pair matching
"set matchpairs+=</>

"show tab characters
set listchars=tab:\|\ "trailing space intentional"
set list

"spellcheck
au FileType gitcommit set spell
