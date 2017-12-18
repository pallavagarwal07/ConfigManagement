let vimDir = '$HOME/.vim'
if has('nvim')
  let vimDir = '$HOME/.config/nvim'
endif

if empty(glob(vimDir . '/autoload/plug.vim'))
    execute "!curl -fLo " . vimDir . "/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
endif

let g:python_host_prog=join(split(system('which nvim-python 2>/dev/null >&2 && which nvim-python || which python')), " ")

call plug#begin(vimDir . '/plugged')
Plug 'scrooloose/nerdcommenter'                                      " Comment fast and professionally
Plug 'scrooloose/nerdtree' , {'on': 'NERDTreeToggle'}                " Proper file explorer inside vim
Plug 'flazz/vim-colorschemes'                                        " All popular Colorscheme
Plug 'tpope/vim-surround'                                            " Quick Surround with tags or Brackets
Plug 'octol/vim-cpp-enhanced-highlight'                              " Enhanced syntax highlight for CPP files
Plug 'Lokaltog/vim-easymotion'                                       " Quick jumping between lines
Plug 'myusuf3/numbers.vim'                                           " Auto Toggle between relative and normal numbering
Plug 'sjl/gundo.vim'                                                 " Graphical undo tree
Plug 'marcweber/vim-addon-mw-utils'                                  " Vim Addons
Plug 'garbas/vim-snipmate'                                           " Snippets for reusable code
Plug 'tpope/vim-fugitive'                                            " Git Wrapper
Plug 'tomtom/tlib_vim'                                               " Needed for SnipMate :(
Plug 'vim-scripts/auto-pairs-gentle'                                 " Auto insert matching brackets
Plug 'vim-scripts/autoswap.vim'                                      " Make vim stop with swap messages intelligently
Plug 'godlygeek/tabular'                                             " Beautiful Alignment when needed
Plug 'plasticboy/vim-markdown'                                       " Better Markdown support for vim (NEEDS TABULAR)
Plug 'jceb/vim-orgmode'                                              " Add OrgMode support like Emacs
Plug 'vim-scripts/cmdalias.vim'                                      " Set up alias for accidental commands
Plug 'nvie/vim-flake8'                                               " Point out PEP8 inconsistencies
Plug 'bling/vim-airline'                                             " Who doesn't know about vim airline plugin
Plug 'kien/ctrlp.vim'                                                " Fast fuzzy file searching
Plug 'terryma/vim-multiple-cursors'                                  " Multiple Cursors like Sublime Text
Plug 'kchmck/vim-coffee-script'                                      " Highlighting and syntax for coffeescript
Plug 'fatih/vim-go'                                                  " Go completion and features
Plug 'KabbAmine/zeavim.vim'                                          " Direct documentation access
Plug 'Superbil/llvm.vim', { 'for': 'llvm' }                          " LLVM highlighting
Plug 'LnL7/vim-nix', { 'for': 'nix' }
Plug 'thanthese/Tortoise-Typing'
Plug 'kh3phr3n/python-syntax'
Plug 'derekwyatt/vim-scala'
Plug 'majutsushi/tagbar'
Plug 'digitaltoad/vim-pug'
Plug 'leafgarland/typescript-vim'
Plug 'dietsche/vim-lastplace'
Plug 'rust-lang/rust.vim'
Plug 'tpope/vim-sleuth'
Plug 'rust-lang/rust.vim'
Plug 'floobits/floobits-neovim'
Plug 'osyo-manga/vim-over'
Plug 'derekelkins/agda-vim'
Plug 'Chiel92/vim-autoformat'
Plug 'rhysd/vim-goyacc'
call plug#end()                                                      " Vundle ends here

set shiftwidth=4                                                     " Indentation
syntax on
filetype plugin indent on

colorscheme jellybeans                                               " Set active Colorscheme
nnoremap ,; ;
                                                                     " start commands with ; not :
nnoremap ; :
                                                                     " Turn word to uppercase in insert mode
inoremap <c-u> <Esc>viwUea
                                                                     " Toggle NERDTree without python compile files
inoremap <F2> <Esc>:NERDTreeToggle<CR>a
                                                                     " Toggle NERDTree without python compile files
nnoremap <F2> :NERDTreeToggle<CR>
                                                                     " Turn on/off wrapping
nnoremap <F4> :set wrap!<CR>
                                                                     " Show open buffers and help in quick switching
nnoremap <F5> :buffers<CR>:buffer<Space>
                                                                     " Turn on/off current line highlight
nnoremap <F9> :set cul!<CR>
                                                                     " Indent everything in insert mode
inoremap <F10> <Esc>mmgg=G`ma
                                                                     " Indent everything in normal mode
nnoremap <F10> <Esc>mmgg=G`m
                                                                     " comment current line with //
nmap // <leader>ci
                                                                     " comment current selection with //
vmap // <leader>ci
                                                                     " w!! force write with sudo even if forgot sudo vim
cmap w!! w !sudo tee > /dev/null %<CR>:e!<CR><CR>
                                                                     " Easy Motion shortcut. Try it!
nmap ,, <leader><leader>s

inoremap jk <Esc>
nnoremap <CR> o<Esc>
nnoremap  <silent>   <tab>  mq:bnext<CR>`q
nnoremap  <silent> <s-tab>  mq:bprevious<CR>`q
                                                                     " Switch buffers with Tab and Shift-Tab
inoremap <// </<C-X><C-O><C-[>m'==`'
nnoremap Q !!sh<CR>
                                                                     " Replace current line with output of shell
cnoremap %s/ OverCommandLine<cr>%sr<BS>/

                        " --------------------------------CONFIGS----------------------------- "

let NERDTreeIgnore=['\.pyc$', '__pycache__']                         " Ignoring .pyc files and __pycache__ folder
let g:go_fmt_command = "goimports"                                   " Rewrite go file with correct imports
let g:over_enable_cmd_window = 1
set wildignore+=*/bin/*,main,*/__pycache__/*,*.pyc,*.swp
set backspace=indent,eol,start                                       " Make backspace work with end of line and indents
set foldmethod=syntax                                                " Auto Add folds - Trigger with za
set foldlevel=9999                                                   " Keep folds open by default
set scrolloff=10                                                     " Scroll Offset below and above the cursor
set sidescroll=1                                                     " How many columns to scroll at once on moving right
set sidescrolloff=20                                                 " Scroll offset on scrolling horizontally
set expandtab                                                        " Replace tab with spaces
set tabstop=4                                                        " Tab = 4 Space
"set softtabstop=4                                                   " Act like there are tabs not spaces
set hidden                                                           " Hide abandoned buffers without message
set wildmenu                                                         " Tab command completion in vim
set ignorecase                                                       " Ignore case while searching
set smartcase                                                        " Case sensitive if Capital included in search
set incsearch                                                        " Incremental Searching - Search as you type
set autoindent                                                       " Self explained
set smartindent
set relativenumber                                                   " relative numbering (Current line in line 0)
set number                                                           " Line numbers - Hybrid mode when used with rnu
set nowrap                                                           " I don't like wrapping statements
set laststatus=2                                                     " Show status line for even 1 file
set mouse=nv                                                         " Allow mouse usage in normal and visual modes
set nohlsearch                                                       " Do not highlight all search suggestions.
set modeline                                                         " Turn on modeline

let g:airline_powerline_fonts = 1                                    " Powerline fonts
let g:airline#extensions#tabline#enabled = 1                         " Show buffers above
let g:agda_extraincpaths = ["/home/pallav/courses/popl/agda/1.3"]

if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    call system('mkdir -p' . vimDir)
    call system('mkdir -p' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
endif


" Lint Configs
" let g:clang_format#style_options = {
"             \ "AccessModifierOffset" : -4,
"             \ "IndentWidth" : 4,
"             \ "TabWidth" : 4,
"             \ "AllowShortIfStatementsOnASingleLine" : "false",
"             \ "AllowShortBlocksOnASingleLine" : "false",
"             \ "AllowShortLoopsOnASingleLine" : "false",
"             \ "AllowShortFunctionsOnASingleLine" : "false",
"             \ "AlwaysBreakTemplateDeclarations" : "true",
"             \ "PointerAlignment" : "Right",
"             \ "DerivePointerAlignment" : "false",
"             \ "SortIncludes" : "false",
"             \ "ColumnLimit" : 90,
"             \ "Standard" : "Auto" }

let g:multi_cursor_insert_maps = {'j':1}


"---------------------------SMART CLIPBOARD----------------------------"
vnoremap ,y "+y
nnoremap ,y "+yy
vnoremap ,d "+d
nnoremap ,d "+dd
vnoremap ,p "+p
nnoremap ,p "+p
vnoremap ,P "+P
nnoremap ,P "+P
"----------------------------ABBREVIATIONS-----------------------------"
iabbrev @@g pallavagarwal07@gmail.com
iabbrev @@i pallavag@iitk.ac.in
iabbrev @@c pallavag@cse.iitk.ac.in

"---------------------------HABIT--BREAKING----------------------------"
inoremap <left> <nop>
nnoremap <left> <nop>
inoremap <right> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
nnoremap <up> <nop>
inoremap <down> <nop>
nnoremap <down> <nop>

                        "----------------------------GVIM SPECIFIC-----------------------------"
execute "set directory=" . expand(vimDir . "/tmp")
                                                                     " Swap files in a single place
execute "set backupdir=" . expand(vimDir . "/tmp")
call system("mkdir -p ". expand(vimDir . "/tmp"))
set guioptions-=m                                                    " remove menu bar
set guioptions-=T                                                    " remove toolbar
set guioptions-=r                                                    " remove right-hand scroll bar
set guioptions-=L                                                    " remove left-hand scroll bar
set guifont=Source\ Code\ Pro\ for\ Powerline\ 12

                        "--------------------------------HOOKS---------------------------------"
augroup filetype_compile
  autocmd!
  autocmd FileType tex nnoremap <F3> mm:w<CR>:!pdflatex<Space>%<CR><CR><Return>`m
augroup END

autocmd FileType python inoremap # X<c-h>#
autocmd BufRead,BufNewFile *.flix set filetype=flix
" autocmd BufWritePre *.c,*.h,*.cpp,*.objc,*.cc ClangFormat
autocmd FileType agda inoremap <localleader>BB 𝔹
autocmd FileType agda cnoremap <localleader>BB 𝔹
autocmd FileType agda inoremap <localleader>BV 𝕍
autocmd FileType agda cnoremap <localleader>BV 𝕍
"autocmd BufWrite * :Autoformat

                        "---------------------------OPERATOR-PENDING---------------------------"
" Operate inside next block
onoremap in( :<c-u>normal! f(vi(<CR>
onoremap in{ :<c-u>normal! f{vi{<CR>
onoremap in" :<c-u>normal! f"vi"<CR>
onoremap in' :<c-u>normal! f'vi'<CR>
onoremap in` :<c-u>normal! f`vi`<CR>
" Operate inside previous block
onoremap ip( :<c-u>normal! F)vi(<CR>
onoremap ip{ :<c-u>normal! F}vi{<CR>
onoremap ip" :<c-u>normal! F"vi"<CR>
onoremap ip' :<c-u>normal! F'vi'<CR>
onoremap ip` :<c-u>normal! F`vi`<CR>
" Operate around next block
onoremap an( :<c-u>normal! f(va(<CR>
onoremap an{ :<c-u>normal! f{va{<CR>
onoremap an" :<c-u>normal! f"va"<CR>
onoremap an' :<c-u>normal! f'va'<CR>
onoremap an` :<c-u>normal! f`va`<CR>
" Operate around previous block
onoremap ap( :<c-u>normal! F)va(<CR>
onoremap ap{ :<c-u>normal! F}va{<CR>
onoremap ap" :<c-u>normal! F"va"<CR>
onoremap ap' :<c-u>normal! F'va'<CR>
onoremap ap` :<c-u>normal! F`va`<CR>

if argc() > 1
  silent blast " load last buffer
  silent bfirst " switch back to the first
endif

"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
" place &~/.config/nvim/init.vim&
" vim: nowrap:
