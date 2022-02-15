" Plug {{{
call plug#begin('~/.config/nvim/plugged')

" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'c-brenn/phoenix.vim'
Plug 'fatih/vim-go'
Plug 'vim-test/vim-test'
Plug 'junegunn/vader.vim'
Plug 'plasticboy/vim-markdown'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'mattn/emmet-vim'
Plug 'jlanzarotta/bufexplorer'

" LSP and Treesitter (nvim 0.5.0 enhancements)
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'hrsh7th/nvim-cmp' " -- Autocompletion plugin
Plug 'hrsh7th/cmp-nvim-lsp' " -- LSP source for nvim-cmp
Plug 'saadparwaiz1/cmp_luasnip' " -- Snippets source for nvim-cmp
Plug 'L3MON4D3/LuaSnip' " -- Snippets plugin
Plug 'rafamadriz/friendly-snippets' " -- Snippet library

" Telescope
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Async linting
Plug 'dense-analysis/ale'

" Vim, Tmux, and Airline theming
Plug 'vim-airline/vim-airline'
Plug 'dracula/vim'

" Language support
Plug 'sheerun/vim-polyglot'

" Configure alchemist for Elixir development
Plug 'slashmili/alchemist.vim'

" Shopify Specific Plugins
Plug 'Shopify/shadowenv.vim'

call plug#end()
" }}}

" Colors/Theme {{{
set background=dark
silent! colorscheme dracula
" }}}

" Base Configuration {{{
set nocompatible
filetype off
filetype plugin indent on

set ttyfast

set laststatus=1
set encoding=utf-8              " Set default encoding to UTF-8
set autoread                    " Automatically reread changed files without asking me anything
set autoindent
set backspace=indent,eol,start  " Makes backspace key more powerful.
set incsearch                   " Shows the match while typing
set hlsearch

" Basic vim settings
set hidden
set visualbell
set number
set nobackup
set noswapfile
set noshowmode

" Set the terminal's title
set title

" Global tab width.
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Set to show invisibles (tabs & trailing spaces) & their highlight color
set list listchars=tab:»\ ,trail:·

" Configure spell checking
nmap <silent> <leader>p :set spell!<CR>
set spelllang=en_us

" Customize completion menu
set completeopt=noinsert,menuone,noselect

" Set leader to comma
let mapleader = ","

" Send all vim registers to the mac clipboard
set clipboard+=unnamedplus
if executable("pbcopy") && executable("pbpaste")
  let g:clipboard = {
    \   'name': 'hasPbCopy',
    \   'copy': {
    \      '+': ['pbcopy'],
    \      '*': ['pbcopy'],
    \    },
    \   'paste': {
    \      '+': ['pbpaste'],
    \      '*': ['pbpaste'],
    \   },
    \   'cache_enabled': 1,
    \ }
endif

" Default to magic mode when using substitution
cnoremap %s/ %s/\v
cnoremap \>s/ \>s/\v
" }}}

" Terminal Mode Configuration {{{
" Terminal mode mappings
tnoremap <Esc> <C-\><C-n>
" }}}

" Helper Functions and Mappings {{{
" Easily manage quick fix windows
map <silent> <C-n> :cnext<CR>
map <silent> <C-m> :cprevious<CR>
nnoremap <silent> <leader>q :cclose<CR>

" Buffer Navigation
nnoremap <silent> ; :BufExplorer<CR>
nnoremap <silent> <Tab> :bn<CR>
nnoremap <silent> <S-Tab> :bp<CR>
nnoremap <silent> <leader>x :bp\|bd #<CR>

" Capture current file path into clipboard
function! CaptureFile()
  let @+ = expand('%')
endfunction
map <leader>f :call CaptureFile()<cr>

" Rename current file
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>

" Strip whitespace on save
fun! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfun

command -nargs=0 Stripwhitespace :call <SID>StripTrailingWhitespaces()

" Fix indentation in file
map <leader>i mmgg=G`m<CR>

" Toggle highlighting of search results
nnoremap <leader><space> :nohlsearch<cr>

" Unsmart Quotes
nnoremap gudq :%s/\v[“”]/"/g<cr>
nnoremap gusq :%s/\v[‘’]/'/g<cr>
" }}}

" emmet-vim {{{
let g:user_emmet_settings = {
\  'javascript' : {
\      'extends' : 'jsx',
\  },
\}
" }}}

" HTML Escaping {{{
nnoremap <Leader>h :'[,']call HtmlEscape()<CR>
vnoremap <Leader>h :call HtmlEscape()<CR>

function HtmlEscape()
  silent s/&/\&amp;/eg
  silent s/</\&lt;/eg
  silent s/>/\&gt;/eg
endfunction
" }}}

" vim-markdown {{{
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_folding_disabled = 1
" }}}

" vim-go {{{
let g:go_metalinter_autosave = 1
let g:go_metalinter_autosave_enabled = ['vet', 'golint']
let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"
let g:go_snippet_engine = "neosnippet"
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_extra_types = 1
let g:go_auto_type_info = 1
let g:go_auto_sameids = 1
" }}}

" vim-json {{{
let g:vim_json_syntax_conceal = 0
" }}}

" vim-test {{{
let test#strategy = "neovim"

" Add hotkeys for vim-test
nmap <silent> <leader>t :TestFile<CR>
nmap <silent> <leader>T :TestNearest<CR>
nmap <silent> <leader>a :TestSuite<CR>
nmap <silent> <leader>l :TestLast<CR>
nmap <silent> <leader>g :TestVisit<CR>
" }}}

" vim-polyglot {{{
let g:jsx_ext_required = 0
" }}}

" LSP, Autocomplete, Snippets

lua << EOF
local ok1, nvim_lsp = pcall(require, 'lspconfig')
local ok2, luasnip = pcall(require, 'luasnip')
local ok3, cmp = pcall(require, 'cmp')

if ok1 and ok2 and ok3 then
  luasnip.filetype_extend("ruby", {"rails"})

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.documentationFormat = { 'markdown', 'plaintext' }
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  capabilities.textDocument.completion.completionItem.preselectSupport = true
  capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
  capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
  capabilities.textDocument.completion.completionItem.deprecatedSupport = true
  capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
  capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
  capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = {
      'documentation',
      'detail',
      'additionalTextEdits',
    },
  }

  -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
  local servers = { 'clangd', 'sorbet', 'tsserver' }
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      -- on_attach = my_custom_on_attach,
      capabilities = capabilities,
    }
  end

  cmp.setup {
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end,
    },
    mapping = {
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-d>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.close(),
      ['<CR>'] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Replace,
        select = true,
      },
      ['<Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end,
      ['<S-Tab>'] = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    }),
  }
end

EOF

" }}}


" Telescope {{{
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <c-p> <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

if exists('*Telescope')
  lua require('telescope').load_extension('fzf')
endif
" }}}


" Auto-commands {{{
if has("autocmd")
  " always start terminal in insert mode
  autocmd BufWinEnter,WinEnter term://* startinsert

  " StripTrailingWhitespaces
  autocmd BufWritePre * Stripwhitespace

  " To spell check all git commit messages
  au BufNewFile,BufRead COMMIT_EDITMSG set spell nonumber nolist wrap linebreak

  " Set filetype tab settings
  autocmd FileType ruby,json,haml,eruby,yaml,html,javascript,coffee,sass,cucumber,stylus,css,xml,htmldjango set ai ts=2 sw=2 sts=2 et
  autocmd FileType python,doctest set ai ts=4 sw=4 sts=4 et

  " Enable auto-completion
  autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
  autocmd FileType html setlocal omnifunc=htmlcomplete#CompleteTags
  autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
  " autocmd FileType javascript nnoremap gp :silent %!prettier --stdin --stdin-filepath % --trailing-comma all --single-quote<CR>

  " Set Syntax Highlighting for odd file types
  augroup filetypedetect
    au BufNewFile,BufRead .gitconfig,.git/* set noet
    au BufNewFile,BufRead Dockerfile* setf dockerfile
    au BufNewFile,BufRead *.fizz setf fizz
    au BufNewFile,BufRead .tmux.conf*,tmux.conf* setf tmux
    au BufNewFile,BufRead .nginx.conf*,nginx.conf* setf nginx
  augroup END

  " Set Ruby specific settings
  au FileType ruby nmap <leader>bp orequire "pry"; binding.pry<esc>^

  " Set Elixir specific settings
  au FileType elixir nmap <leader>bp orequire IEx; IEx.pry<esc>^

  " Set Go specific mappings
  au FileType go set ai ts=2 sw=2 sts=2 noet nolist autowrite
  au FileType fizz set ai ts=2 sw=2 sts=2 noet nolist autowrite

  " Set ERB specific settings
  au FileType eruby nmap <leader>bp o<% require "pry"; binding.pry %><esc>^

  " Restore cursor position
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
endif
" }}}
