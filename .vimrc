" Keith Thompson

" Pathogen {{{
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()
" }}}

" Colors {{{
set t_Co=256                        " set number of colors
colorscheme Tomorrow-Night-Eighties " Use Tomorrow-Night Theme
" }}}

" Leader & General Commands {{{
" Use 'jj' to esc
inoremap jj <esc>
let mapleader= "," " Remap Leader to ,

" Fix indentation in file
map <leader>i mmgg=G`m<CR>
" }}}

" UI {{{
filetype plugin indent on " enable filetype detection, plugins and indentation
syntax on           " turn on file syntax highlighting
set number          " show line numbers
set ruler           " show cursor position in bottom bar (vim-airline overrides)
set cursorline      " visually show which line the cursor is on
set autoindent      " match indentation level when adding new lines
set showcmd         " show previous window command in bottom line
set laststatus=2    " Always display the last status
set mouse=a         " Enable mouse in all 4 modes
set noerrorbells visualbell t_vb= " disable audio/visual messages for failed commands
set wildmenu        " Display menu when autocomplete hase more than 1 possible value
set wildignore+=*.o,*.obj,.git,*.pyc,parts,*.egg-info,node_modules,tmp,venv,build,resources,vendor,tags " list of things to not tab complete
set lazyredraw      " Only redraw when necessary (makes macros execute faster)
set showmatch       " highlight matching character for [{()}]
set winwidth=84     " when going into a window or split it will then take at least 84 columns of width
set winheight=5     " set winheight low to set winminheight
set winminheight=5  " minimum height allowed for a window
set winheight=999   " active window takes maximum height
set shell=/bin/bash " use the proper path
set nocompatible    " make vim behave like vim and not vi
set list listchars=tab:»\ ,trail:· " set characters for trailing white space and <Tab> characters
highlight SpecialKey guifg=#FF003F " set color for hidden characters
let g:airline_powerline_fonts = 1 " Airline configuration
" set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')} " show kind of token under cursor in status line

" Simple auto closing backets & parenthesis
inoremap (<CR>  (<CR>)<Esc>O
inoremap <expr> ) strpart(getline('.'), col('.')-1, 1) == ")" ? "\<Right>" : ")"
inoremap [<CR>  [<CR>]<Esc>O
inoremap <expr> ] strpart(getline('.'), col('.')-1, 1) == "]" ? "\<Right>" : "]"
inoremap {<CR>  {<CR>}<Esc>O
inoremap <expr> } strpart(getline('.'), col('.')-1, 1) == "}" ? "\<Right>" : "}"

" Custom Single and double quote handling, most people
" probably wouldn't like this
inoremap ""     ""<Left>
inoremap """    """<CR>"""<Esc>kA
inoremap <expr> " strpart(getline('.'), col('.')-1, 1) == '"' ? "\<Right>" : '"'
inoremap ''     ''<Left>
inoremap '''    '''<CR>'''<Esc>kA
inoremap <expr> ' strpart(getline('.'), col('.')-1, 1) == "'" ? "\<Right>" : "'"

" Disable Execute Mode
nmap Q <Nop>
" }}}

" Text {{{
set encoding=utf-8  " set text ecoding to UTF-8
set smarttab        " insert and remove tab widths with <Tab> and <Backspace>
set expandtab       " insert spaces in place of tabs
set textwidth=0     " do not break lines when pasting
set tabstop=2       " number of visual spaces per <Tab>
set softtabstop=2   " number of spaces in <Tab> when editing
set shiftwidth=2    " how far to shift for new indentation level
" }}}

" Search {{{
set incsearch       " start searching before hitting enter
set hlsearch        " highlight search results
set ignorecase      " case insensitive search (when searching with all lower case)
set smartcase       " if search has capital letter then be case sensitive
set backspace=indent,eol,start " set characters that can be backspaced over
set nogdefault      " use the standard /g end character to do global
" Toggle highlighting of search results
nnoremap <leader><space> :nohlsearch<cr>

" re-index ctags in current directory (recursive)
nmap <F4> :!ctags -R .<cr>
" }}}

" Backups {{{
set nobackup        " don't save backups
set nowritebackup   " don't create backups before overwriting a file
set noswapfile      " don't create a swapfile for buffers
" }}}

" Folding {{{
set foldenable         " enable code folding
set foldlevelstart=10  " have most folds open by default
set foldnestmax=10     " only allow up to 10 nested folds
set foldmethod=marker  " use syntax marker to delimit folds
" open fold under cursor with space
nnoremap <space> za
" }}}

" Navigation {{{
" Cycle through open buffers with <Tab> and <Shift>+<Tab>
map <Tab> :bn<CR>
map <S-Tab> :bp<CR>

" Kill current buffer without closing splits with ,x
nnoremap <leader>x :Bdelete<cr>

" Switch windows with ,C
map <leader><S-c> <C-w><C-w>

" Don't use arrow keys
map <Left> :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up> :echo "no!"<cr>
map <Down> :echo "no!"<cr>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
" }}}

" CtrlP {{{
" Order file matches from bottom to top
let g:ctrlp_match_window = "bottom,order:btt"
" Always open new files in new buffers
let g:ctrlp_switch_buffer = 0
" Respect current working directory and don't change based on current buffer
let g:ctrlp_working_path_mode = 0
" Use ag for the searching so that it's not so slow
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
" }}}

" Auto-complete {{{
" MULTIPURPOSE TAB KEY (taken from Gary Bernhardt)
" Indent if we're at the beginning of a line. Else, do completion.
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<tab>"
  else
    return "\<c-p>"
  endif
endfunction
" either tab or smart complete depending on location
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
" open wildmenu with Shift+Tab
inoremap <s-tab> <c-n>
" }}}

" Functions {{{
" Function for removing trailing white space on save
function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

" RENAME CURRENT FILE
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' .old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>
" }}}

" Testing Functions {{{
" SWITCH BETWEEN TEST AND PRODUCTION CODE
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = currenct_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

" RUN TESTS
function! RunTests(filename)
  " Write the file and run tests for the given filename
  :w
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
  if match(a:filename, '\.feature$') != -1
    if filereadable("script/features")
      exec ":!script/features " . a:filename
    elseif filereadable("Gemfile")
      exec ":!bundle exec cucumber " . a:filename
    else
      exec ":!cucumber " . a:filename
    end
  else
    if filereadable("script/test")
      exec ":!script/test " . a:filename
    elseif filereadable("Gemfile")
      exec ":!bundle exec ruby ". a:filename
    else
      exec ":!ruby " . a:filename
    end
  end
endfunction

function! SetTestFile()
  " Set the spec file that tests will be run for.
  let t:grb_test_file=@%
endfunction

function! RunTestFile(...)
  if a:0
    let command_suffix = a:1
  else
    let command_suffix = ""
  endif

  " Run the test for the previously-marked file.
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\|_test.rb\)$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction

" Running Ruby & Cucumber Tests
map <leader>a :call RunTests('')<cr>
map <leader>t :call RunTestFile()<cr>
map <leader>c :!bundle exec cucumber<cr>
" }}}

" Auto-commands {{{
" Set up filetype specific commands
if has("autocmd")
  " Set filetype tab settings
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,coffee,sass,cucumber,stylus,css,xml,htmldjango set ai ts=2 sw=2 sts=2 et
  autocmd FileType python,doctest set ai ts=4 sw=4 sts=4 et
  autocmd FileType go set ai ts=2 sw=2 sts=2 noet

  " Set auto-complete settings for various file types
  autocmd FileType css,scss set omnifunc=csscomplete#CompleteCSS

  " Set Syntax Highlighting for odd file types
  au BufNewFile,BufRead *.ejs set filetype=jst
  au BufNewFile,BufRead *.json set filetype=json syntax=javascript
  au BufNewFile,BufRead *.md set filetype=markdown
  au BufNewFile,BufRead Podfile,Vagrantfile set ft=ruby
  au BufNewFile,BufRead .git*,.git/* set noet
  au BufNewFile,BufRead *.hd set ft=handlebars
  au BufNewFile,BufRead Gruntfile set filetype=javascript

  " Automatically Strip Trailing Whitespace on Save
  autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

  " Restore cursor position
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Set Go specific commands
  autocmd FileType go map <buffer> <leader>t :w \|:!go test<cr>
  autocmd FileType go map <buffer> <leader>r :w \|:!go run %<cr>
endif
" }}}

" vim:foldmethod=marker:foldlevel=0
