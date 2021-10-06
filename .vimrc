" =============================================================================
" # INITIAL SETUP
" =============================================================================

if !isdirectory($HOME.'/.vim') | call mkdir($HOME.'/.vim', '', 0700) | endif
if !isdirectory($HOME.'/.vim/undodir') | call mkdir($HOME.'/.vim/undodir', '', 0700) | endif

let g:hardtime_default_on = 0
let g:remoteSession = !($SSH_TTY ==? '')
if g:remoteSession | colorscheme slate | else | colorscheme default | endif
if filereadable('/bin/fish') | set shell=/bin/fish\ --login | else | set shell=/bin/bash\ --login | endif

let mapleader = "\<Space>"

" bugfixes
" vint: -ProhibitSetNoCompatible
set nocompatible                    " Disable vi compatibility
set t_RV= t_ut=                     " disable term version query, bg color erase
let &t_Cs="\e[4:3m"                 " tell vim how to print undercurl
let &t_Ce="\e[4:0m"                 " and end it. Should be detected, but nope

" =============================================================================
" # VISUAL SETTINGS
" =============================================================================

" Visual settings
syntax enable                       " Syntax highlighting for applicable buffers
set noshowmode showmatch            " Hide MODE on statusbar, highlight paired symbols
set wrap linebreak display=lastline " Wrap display line between words, no filler chars
set scrolloff=10 sidescrolloff=10   " Visual buffer around editing area
set noerrorbells novisualbell       " No bells
set background=dark                 " Make Vim use the correct colors in my scheme
hi clear SignColumn                 " For some reason, sign column wasn't using bgcolor
if has('nvim')
  " TODO
else
  hi DiffAdd     cterm=italic     ctermfg=Green    ctermbg=none
  hi DiffChange  cterm=none       ctermfg=Yellow   ctermbg=none
  hi DiffDelete  cterm=bold       ctermfg=Red      ctermbg=none
  hi DiffText    cterm=undercurl  ctermul=Yellow   ctermbg=none
  hi SpellBad    cterm=undercurl  ctermul=Red      ctermbg=none
  hi ALEWarning  cterm=undercurl  ctermbg=none     ctermul=blue
  hi ALEError    cterm=undercurl  ctermbg=none     ctermul=red
  hi MatchWord   cterm=underline  gui=underline
endif

" =============================================================================
" # EDITOR SETTINGS
" =============================================================================

" Functional settings
set encoding=utf8 termencoding=utf8 " Always write utf-8 encoded files
scriptencoding=utf8                 " This file has multibyte chars
set backspace=indent,eol,start      " Allow backspace across [chars]
set autoread hidden                 " Reload on change, allow unfocused edited buffers
set ttyfast lazyredraw              " Render faster, don't render during commands
set undofile undodir=~/.vim/undodir history=5000  " Maintain history
if !g:hardtime_default_on | set mouse=a | else | set mouse= | endif
set splitbelow splitright           " Split like i3
set clipboard^=unnamedplus          " Use system clipboard always
set ignorecase smartcase hlsearch incsearch       " Convenient search options
set shiftround expandtab shiftwidth=4 tabstop=4   " Tab behavior defaults
set textwidth=80 formatoptions+=c  " Wrap to newline at textwidth, respecting comments
set formatoptions-=t
set completeopt=menuone,noinsert,noselect   " Use menu, don't insert/select unless user chooses
set autochdir                      " Ensure working directory = directory of vim
set foldmethod=syntax              " Use syntax to define folds
filetype plugin indent on          " Autoindent+plugins per filetype


" Information settings
set ruler number relativenumber     " sidebar line numbers, statusbar column number
set wildmenu wildmode=longest:full,list     " command completion menu behavior
set showcmd                         " show currently typed command

" Completion
set completeopt=menuone,noinsert,noselect
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300


" =============================================================================
" # PLUGINS
" =============================================================================

call plug#begin()
    " VIM enhancements
    Plug 'editorconfig/editorconfig-vim'
    Plug 'justinmk/vim-sneak'

    " Language support
    Plug 'dense-analysis/ale'                   " Linting, completion, formatting
    Plug 'jpalardy/vim-slime'                   " Send buffer data to [session]

    " GUI enhancements
    Plug 'airblade/vim-gitgutter'               " Gitlens for vim
    Plug 'andymass/vim-matchup'                 " Extend % matching
    Plug 'machakann/vim-highlightedyank'        " Highlight yanked lines
    Plug 'tpope/vim-fugitive'                   " Git information and commands
    Plug 'vim-airline/vim-airline'              " Fancy status bar

    " Fuzzy finder
    Plug 'airblade/vim-rooter'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'


    " Convenience
    Plug 'ConradIrwin/vim-bracketed-paste'      " Automatic :set paste
    Plug 'raimondi/delimitmate'                 " Auto match parens
    Plug 'godlygeek/tabular', { 'for': 'markdown' }
    Plug 'mattn/emmet-vim', { 'for': 'html' }
    Plug 'tpope/vim-commentary'                 " Plugin for commenting code
    Plug 'tpope/vim-sleuth'                     " Auto-adjust tab behavior based on open file
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-unimpaired'			        " Better bracket binds
    Plug 'takac/vim-hardtime'                   " Become better
    Plug 'kkvh/vim-docker-tools'

    " Auto complete suggestions
    Plug 'ervandew/supertab'                    " Smart tab complete
    if has('nvim')
      Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    else
      Plug 'Shougo/deoplete.nvim'               " More supported completion pop-up
      Plug 'roxma/nvim-yarp'
      Plug 'roxma/vim-hug-neovim-rpc'
    endif

    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
    Plug 'lervag/vimtex', {'for': ['tex', 'plaintex']}        " LaTeX previewer, \ll to start
    Plug 'sirver/ultisnips'                 " Faster snippets completion
    Plug 'honza/vim-snippets'
call plug#end()

""""""""""""""""""""""""""""""""""""""""""
" Plugin Settings

" ALE
let g:ale_lint_delay = 500
let g:ale_fix_on_save = 1
let g:ale_set_balloons = 1
let g:ale_echo_msg_info_str = '🛈 '
let g:ale_echo_msg_warning_str = '⚠ '
let g:ale_echo_msg_error_str = '❌'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linter_aliases = {'jsx': ['javascript']}
let g:ale_completion_autoimport = 1
set omnifunc=ale#completion#OmniFunc
let g:ale_linters = {
                \   'c': ['cc', 'clangtidy', 'clangd'],
                \   'cpp': ['cc', 'clangtidy', 'clangd'],
                \   'css': ['stylelint', 'prettier'],
                \   'dockerfile': ['hadolint'],
                \   'html': ['stylelint', 'tidy'],
                \   'java': ['javac', 'eclipselsp'],
                \   'javascript': ['eslint', 'tsserver'],
                \   'json': ['jsonlint'],
                \   'markdown': ['alex', 'proselint', 'writegood', 'textlint'],
                \   'python': ['bandit', 'flake8', 'pyls',  'pyright'],
                \   'rust': ['cargo', 'rls'],
                \   'sh': ['shell', 'shellcheck', 'language_server'],
                \   'sql': ['sqlint', 'sql-language-server'],
                \   'toml': ['tomlcheck'],
                \   'vim': ['vint', 'vimls'],
                \   'yaml': ['yamllint'],
                \   }
let g:ale_fixers =  {
                \   '*': ['remove_trailing_lines', 'trim_whitespace'],
                \   'c': ['clang-format'],
                \   'cpp': ['clang-format'],
                \   'css': ['prettier'],
                \   'dockerfile': [],
                \   'html': ['prettier'],
                \   'java': ['google_java_format'],
                \   'javascript': ['eslint', 'prettier'],
                \   'typescript': ['tslint'],
                \   'json': ['prettier'],
                \   'markdown': ['prettier'],
                \   'python': ['isort', 'black'],
                \   'rust': ['rustfmt'],
                \   'sh': ['shfmt'],
                \   'sql': ['pgformatter'],
                \   'vim': ['remove_trailing_lines', 'trim_whitespace'],
                \   'yaml': ['prettier'],
                \   }
let g:ale_virtualenv_dir_names = []
let g:ale_rust_cargo_use_clippy = 1

command! ALEToggleFixer execute "let g:ale_fix_on_save = get(g:, 'ale_fix_on_save', 0) ? 0 : 1"
noremap gd :ALEGoToDefinition<CR>
noremap K :ALEHover<CR>
noremap <Leader>D :ALEGoToTypeDefinition<CR>
noremap <Leader>a :ALECodeAction<CR>
noremap gr :ALEFindReferences<CR>
noremap <Leader>e :ALEDetail<CR>
noremap <Leader>r :ALEResetBuffer<CR>
noremap <Leader>f :ALEFix<CR>
noremap <Leader>rn :ALERename<CR>

" Vim-slime
let g:slime_target = 'vimterminal'                  " Session to send to
let g:slime_paste_file = '$HOME/.vim/.slime_paste'  " Cleaner selection for paste file
let g:slime_python_ipython = 1                      " Ipython drops inputs without this

" Airline
if !exists('g:airline_symbols') | let g:airline_symbols = {} | endif
let g:airline_powerline_fonts = 1
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.crypt = '🔐'
let g:airline_symbols.readonly = '🔒'
let g:airline_symbols.linenr = ' '
let g:airline_symbols.maxlinenr = ''
let g:airline_symbols.colnr = ':'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.spell = '✓'
let g:airline_symbols.dirty='*'
let g:airline_symbols.notexists = 'Ɇ'
let g:airline#extensions#branch#displayed_head_limit = 16   " limit branch names to first 16 chars
let g:airline#extensions#tabline#enabled = 1                " display open buffers+tabs on top bar
let g:airline#extensions#tabline#fnamecollapse = 2          " only show 2 trunc'd parent dirs
let g:airline#extensions#tabline#nametruncate = 16          " max buffer name of 16 chars
let g:airline#extensions#tabline#buffer_idx_mode = 1        " show buffer index  on tabline

" Markdown-preview.nvim
let g:mkdp_browser = 'firefox'

" Vimtex
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_compiler_progname = 'tectonic'
let g:tex_conceal='abdmg'

let g:UltiSnipsEditSplit='vertical'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsExpandTrigger='<NUL>'
" https://github.com/SirVer/ultisnips/issues/376
let g:ulti_expand_or_jump_res = 0
function ExpandSnippetOrCarriageReturn()
  let snippet = UltiSnips#ExpandSnippetOrJump()
  if g:ulti_expand_or_jump_res > 0 | return snippet | else | return "\<CR>" | endif
endfunction
inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"


" Deoplete
call deoplete#custom#option('sources', {
\ '_': ['ale', 'ultisnips'],
\})
let g:deoplete#enable_at_startup = 1

" Vimspector
let g:vimspector_enable_mappings = 'HUMAN'

" Vim sneak
let g:sneak#label = 1

" Yank highlight
let g:highlightedyank_highlight_duration = 300

" Supertab
let g:SuperTabDefaultCompletionType = '<c-n>'

" Hardtime
let g:hardtime_allow_different_key = 1
" No arrow keys --- force yourself to use the home row
let g:list_of_disabled_keys = ['<UP>', '<DOWN>', '<LEFT>', '<RIGHT>', '<PAGEUP>', '<PAGEDOWN>']

" =============================================================================
" # KEYBOARD SHORTCUTS
" =============================================================================

" ; as :
nnoremap ; :

" Command remaps
command! W :write
command! Q :quit

" Suspend with Ctrl+f
inoremap <C-f> :sus<cr>
vnoremap <C-f> :sus<cr>
nnoremap <C-f> :sus<cr>

" Jump to start and end of line using the home row keys
map H ^
map L $

" Clear search highlight by hitting enter
" Hitting n or performing another search will re-enable
nnoremap <silent> <CR> :noh<CR><CR>

" Allow scroll mode in :term
tnoremap <c-b> <c-\><c-n>

" Open new file adjacent to current file
nnoremap <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

" Move by line
nnoremap j gj
nnoremap k gk

" <leader>, shows/hides hidden characters
nnoremap <leader>, :set invlist<cr>

" <leader>q shows stats
nnoremap <leader>q g<c-g>

" Keymap for replacing up to next _ or -
noremap <leader>m ct_

" Toggle markdown preview
nmap <silent> <C-s> <Plug>MarkdownPreview

" I3-style buffer selection (ignores special buffers)
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <left> <Plug>AirlineSelectPrevTab
nmap <right> <Plug>AirlineSelectNextTab

" Git
nnoremap <leader>gd :Gvdiffsplit!<CR>
nnoremap gdh :diffget //2<CR>
nnoremap gdl :diffget //3<CR>
nnoremap <Leader>gs :Gstatus<CR>
nnoremap <Leader>gb :Git blame<CR>
nnoremap <Leader>gl :Glog<CR>

""""""""""""""""""""""""""""""""""""""""""
" FZF
" <leader>s for Rg search
noremap <leader>s :RG
let g:fzf_layout = { 'down': '~20%' }

" Add namespace for fzf.vim exported commands
let g:fzf_command_prefix = 'Fzf'

" Mappings
nnoremap <silent> <leader>o :FzfFiles<CR>
nnoremap <silent> <leader>O :FzfFiles!<CR>
nnoremap <silent> <leader>b :FzfBuffers<CR>
nnoremap <silent> <leader>` :FzfMarks<CR>
inoremap <silent> <F3> <ESC>:FzfSnippets<CR>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let preview_type = a:fullscreen ? 'up:60%' : 'right:50%:hidden'
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command, '--preview-window', preview_type]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

function! s:list_cmd()
  let base = fnamemodify(expand('%'), ':h:.:S')
  return base == '.' ? 'fd --type file --follow' : printf('fd --type file --follow | proximity-sort %s', shellescape(expand('%')))
endfunction

command! -bang -nargs=? -complete=dir FzfFiles
  \ call fzf#vim#files(<q-args>, {'source': s:list_cmd(),
  \                               'options': '--tiebreak=index'}, <bang>0)


" =============================================================================
" # AUTOCOMMANDS
" =============================================================================

augroup recall_pos | au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif | augroup END
augroup filetype_settings | autocmd FileType md,markdown,svn,*commit* setlocal spell | augroup END
augroup FiletypeGroup | autocmd! | au BufNewFile,BufRead *.jsx set filetype=javascript.jsx | augroup END
