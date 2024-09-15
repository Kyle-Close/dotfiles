"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin stuff
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Initialize vim-plug
call plug#begin('~/.local/share/nvim/plugged')

" List plugins here
Plug 'preservim/nerdtree'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'vimwiki/vimwiki'
Plug 'karb94/neoscroll.nvim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'prettier/vim-prettier', { 'do': 'yarn install --frozen-lockfile --production' }
Plug 'folke/tokyonight.nvim'

" End of plugin section
 call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Remappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader = "a"

" Hit leader + w to save file
nnoremap <leader>w :w<CR>

" Map <leader>o to open fuzzy find buffer
nnoremap <leader>o :Buffers<CR>

" Map <leader>f to open file search
nnoremap <leader>f :Files<CR>

" Use <Enter> to confirm the selection
inoremap <expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

" Hit jj to exit insert mode
inoremap jj <esc>

" Don't want to enter insert mode after making a new linnoremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>e
nnoremap o o<esc>
nnoremap O O<esc>

" Ctrl + n to toggle NERDTree
nmap <C-n> :NERDTreeToggle<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Base settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use the OS clipboard by default (on versions compiled with `+clipboard`)
set clipboard=unnamed

" Set line numbers so it shows the actual line number for current line
set number

" Get relative line numbering
set relativenumber

" Set colorscheme
colorscheme tokyonight

" Have a vertical line when in insert mode
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" Enable filetype plugins
filetype plugin on
filetype indent on

" Vim will detect if the file has been changed from an outside source and reload if needed
set autoread
au FocusGained,BufEnter * silent! checktime

" When scrolling with jk, make sure that there are at least 7 lines above or below the cursor for visibility
set so=7

" Allows auto completion with tab just like the shell
set wildmenu

" Display the cursor position in the bottom right corner
set ruler

" When switching between buffers you won't lose unsaved changes with this setting
set hid

" Backspace acts a bit odd by default in insert mode. This fixes that
set backspace=eol,start,indent

" If at the start of a line pressing h will move to the next line. Same idea for end of line with l
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
set smartcase

" Highlight search results
set hlsearch

" When searching for text this will update the search result in real time
set incsearch

" Makes regular expressions work normal. Otherwise vim does weird things
set magic

" Show matching brackets when text indicator is over them
set showmatch

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable syntax highlighting
syntax enable

" Use dark background
set background=dark

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

" Recognize special characters
set encoding=utf8

" Helps vim recognize what new line terminator to use based on the system
set ffs=unix,dos,mac

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Turn backup off, since most stuff is in SVN, git etc. anyway...
set nobackup
set noswapfile

" Set the location of the undo directory. If the directory does not exist, create one
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif

set undodir=~/.vim/undo-dir
set undofile

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set expandtab       " Convert tabs to spaces
set shiftwidth=2    " Number of spaces to use for each step of (auto)indent
set softtabstop=2   " Number of spaces that a <Tab> counts for while editing
set tabstop=2       " Number of spaces that a <Tab> counts for when displaying
set smarttab
set smartindent

" Make indenting smart by auto indenting new lines based on where we are in a code block for ex
set ai "Auto indent
set si "Smart indent

""""""""""""""""""""""""""""""
" => Visual mode related
""""""""""""""""""""""""""""""

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Use '/' to search for text (forward) and <ctrl + space> to search backwards
map <space> /
map <C-space> ?

" Return to last edit position when opening files
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Editing mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Remap VIM 0 to first non-blank character
map 0 ^

" Delete trailing white space on save
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Settings related to specific plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 

" Automatically format with Prettier on save
autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx,*.css,*.scss,*.md PrettierAsync

" Install Coc extensions if necessary
let g:coc_global_extensions = ['coc-tsserver', 'coc-pyright', 'coc-emmet']

lua << EOF
neoscroll = require('neoscroll')
neoscroll.setup({
  -- Default easing function used in any animation where
  -- the easing argument has not been explicitly supplied
  easing = "quadratic"
})
local keymap = {
  -- Use the "sine" easing function
  ["<C-k>"] = function() neoscroll.ctrl_u({ duration = 250; easing = 'sine' }) end;
  ["<C-j>"] = function() neoscroll.ctrl_d({ duration = 250; easing = 'sine' }) end;
  -- Use the "circular" easing function
  ["<C-b>"] = function() neoscroll.ctrl_b({ duration = 450; easing = 'circular' }) end;
  ["<C-f>"] = function() neoscroll.ctrl_f({ duration = 450; easing = 'circular' }) end;
  -- When no value is passed the easing option supplied in setup() is used
  ["<C-y>"] = function() neoscroll.scroll(-0.25, { move_cursor=false; duration = 100 }) end;
  ["<C-e>"] = function() neoscroll.scroll(0.25, { move_cursor=false; duration = 100 }) end;
}
local modes = { 'n', 'v', 'x' }
for key, func in pairs(keymap) do
    vim.keymap.set(modes, key, func)
end
EOF
