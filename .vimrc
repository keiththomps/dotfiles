" Pathogen lines
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

" Remap Leader to ,
inoremap jj <esc>
let mapleader= ","

" Copy to OS X pasteboard
noremap <leader>y "*y

" Paste from OS X pasteboard without messing up indent.
noremap <leader>p :set paste<CR>:put *<CR>:set nopaste<CR>
noremap <leader>P :set paste<CR>:put! *<CR>:set nopaste<CR>

" Basic setup, enter :help [setting] to see what these are
set encoding=utf-8
set relativenumber
set ruler
set hidden
set smarttab
set expandtab
set textwidth=80
set textwidth=0
set tabstop=2
set softtabstop=2
set shiftwidth=2
set autoindent
set incsearch
set hlsearch
set ignorecase
set smartcase
set wildmenu
set backspace=indent,eol,start
set t_Co=256
set nocompatible
set guioptions-=T
set showcmd
set laststatus=2
set mouse=
set noerrorbells visualbell t_vb=
set wildignore+=*.o,*.obj,.git,*.pyc,parts,*.egg-info,node_modules,tmp,venv,build,resources,vendor,tags
set nobackup
set nowritebackup
set noswapfile
" This fixes the issue with Vim not using the proper path, therefore not
" using my rbenv shims
set shell=/bin/bash
syntax on

" This shows what kind of token is underneath the cursor for theming
" set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}

" turn on all python syntax highlighting
let python_highlight_all=1

" Use Tomorrow-Night Theme
colorscheme Tomorrow-Night-Eighties
" colorscheme Tomorrow

" We have to have a winheight bigger than we want to set winminheight. But if
" we set winheight to be huge before winminheight, the winminheight set will
" fail.
set winwidth=84
set winheight=5
set winminheight=5
set winheight=999

" Set to show invisibles (tabs & trailing spaces) & their highlight color
set list listchars=tab:»\ ,trail:·
highlight SpecialKey guifg=#FF003F

" Allow syntastic sytax checking
let syntastic_enable_signs=1
let syntastic_check_on_open=1
let syntastic_quiet_warnings=1

" Custom Commands for Switching buffers and CommandT
map <Tab> :bn<CR>
map <S-Tab> :bp<CR>
map <leader>x :Kwbd<cr>
map <leader><S-c> <C-w><C-w>
map <leader>f :CommandTFlush<cr>\|:CommandT<cr>

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

" Turn On FileType Detection
filetype plugin indent on
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
inoremap <tab> <c-r>=InsertTabWrapper()<cr>
inoremap <s-tab> <c-n>

" DON't USE ARROW KEYS
map <Left> :echo "no!"<cr>
map <Right> :echo "no!"<cr>
map <Up> :echo "no!"<cr>
map <Down> :echo "no!"<cr>

" Ctags
nmap <F4> :!ctags -R .<cr>
nmap <F8> :TagbarToggle<cr>

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
    exec ":!script/features " . a:filename
  else
    if filereadable("script/test")
      exec ":!script/test " . a:filename
    elseif filereadable("Gemfile")
      exec ":!bundle exec rspec --color ". a:filename
    else
      exec ":!rspec --color " . a:filename
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
  let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
  if in_test_file
    call SetTestFile()
  elseif !exists("t:grb_test_file")
    return
  end
  call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
  let spec_line_number = line('.')
  call RunTestFile(":" . spec_line_number . " -b")
endfunction

" Running Ruby & Cucumber Tests
map <leader>a :call RunTests('')<cr>
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>c :!bundle exec cucumber<cr>

" Python & Django based tests
map <leader>dt :w\|:!python -m doctest %<cr>
map <leader>dT :w\|:!pm test %<cr>
map <leader>h :w\|:!pm harvest<cr>

" Toggle highlighting of search results
nnoremap <CR> :nohlsearch<cr>

" Set up filetype specific commands
if has("autocmd")
  " Set filetype tab settings
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber,stylus,css,xml,htmldjango set ai ts=2 sw=2 sts=2 et
  autocmd FileType python,doctest set ai ts=4 sw=4 sts=4 et

  " Set auto-complete settings for various file types
  autocmd FileType css,scss set omnifunc=csscomplete#CompleteCSS

  " Set Syntax Highlighting for odd file types
  au BufNewFile,BufRead *.ejs set filetype=jst
  au BufNewFile,BufRead *.json set filetype=json syntax=javascript
  au BufNewFile,BufRead *.pt,*.cpt,*.zpt set filetype=zpt syntax=xml
  au BufNewFile,BufRead *.zcml set filetype=zcml syntax=xml
  au BufNewFile,BufRead *.txt set filetype=doctest
  au BufNewFile,BufRead *.md set filetype=markdown
  au BufNewFile,BufRead .git*,.git/* set noet
  au BufNewFile,BufRead *.hamstache set ft=haml
  au BufNewFile,BufRead *.html set ft=htmldjango
  au BufNewFile,BufRead Podfile set ft=ruby

  " This automatically removes the trailing whitespace in specific file types
  autocmd BufWritePre *.py,*.rb,*.css,*.scss,*.js :call <SID>StripTrailingWhitespaces()

  " Restore cursor position
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  " Set Go specific commands
  autocmd FileType go map <buffer> <leader>t :w \|:!go test<cr>
  autocmd FileType go map <buffer> <leader>r :w \|:!go run %<cr>
endif
