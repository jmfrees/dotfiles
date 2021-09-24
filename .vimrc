" =============================================================================
" # INITIAL SETUP
" =============================================================================

let mapleader = "\<Space>"

" Set :term/:shell program
if filereadable('/bin/fish')
    set shell=/bin/fish\ --login
else
    set shell=/bin/bash\ --login
endif

" Prep general vim environment
if !isdirectory($HOME.'/.vim')
    call mkdir($HOME.'/.vim', '', 0700)
endif
if !isdirectory($HOME.'/.vim/undodir')
    call mkdir($HOME.'/.vim/undodir', '', 0700)
endif

" Check if remote session
let g:remoteSession = !($SSH_TTY ==? '')
if g:remoteSession
    colorscheme slate
else
    colorscheme default
endif

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
    Plug 'mhinz/vim-startify'                   " Fancy start screen with recall
    Plug 'ryanoasis/vim-devicons'               " Fancy symbols integration
    Plug 'tpope/vim-fugitive'                   " Git information and commands
    Plug 'vim-airline/vim-airline'              " Fancy status bar

    " Fuzzy finder
    Plug 'airblade/vim-rooter'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'

    " Convenience
    Plug 'ConradIrwin/vim-bracketed-paste'      " Automatic :set paste
    Plug 'jiangmiao/auto-pairs'                 " Auto match parens
    Plug 'godlygeek/tabular', { 'for': 'markdown' }
    Plug 'mattn/emmet-vim', { 'for': 'html' }
    Plug 'tpope/vim-unimpaired'			" Better bracket binds
    Plug 'tpope/vim-commentary'                 " Plugin for commenting code
    Plug 'tpope/vim-sleuth'                     " Auto-adjust tab behavior based on open file

    " Auto complete suggestions
    Plug 'ervandew/supertab'                    " Smart tab complete
    Plug 'Shougo/deoplete.nvim'                 " More supported completion pop-up
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'

    if !g:remoteSession
        Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
        Plug 'lervag/vimtex', {'for': ['tex', 'plaintex']}        " LaTeX previewer, \ll to start
        Plug 'sirver/ultisnips'                 " Faster snippets completion
        Plug 'honza/vim-snippets'
    endif
call plug#end()

""""""""""""""""""""""""""""""""""""""""""
" Plugin Settings

" ALE
let g:ale_lint_delay = 750
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
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 1               " Fancy unicode symbols
let g:airline_left_sep = ''                     " Omit for cleanliness
let g:airline_right_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.crypt = '🔐'              " Encrypted file
let g:airline_symbols.readonly = '🔒'           " Read only file
let g:airline_symbols.linenr = '¶'              " Linenum
let g:airline_symbols.maxlinenr = ''            " Column num
let g:airline_symbols.paste = '∥'               " Paste mode
let g:airline_symbols.spell = '✓'               " Spell mode
let g:airline_symbols.dirty='*'                 " Dirty git buffer
let g:airline_symbols.notexists = 'Ɇ'
let g:airline#extensions#ale#enabled = 1                    " ALE + vim-airline integration
let g:airline#extensions#tabline#enabled = 1                " Display open buffers+tabs on top bar
let g:airline#extensions#tabline#nametruncate = 16          " Max buffer name of 16 chars
let g:airline#extensions#tabline#fnamecollapse = 2          " Only show 2 trunc'd parent dirs
let g:airline#extensions#tabline#buffer_idx_mode = 1        " Show navigable buffer number
let g:airline#extensions#branch#displayed_head_limit = 16   " Limit branch names to first 16 chars

" Markdown-preview.nvim
let g:mkdp_browser = 'firefox'

" Vimtex
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_compiler_progname = 'tectonic'
let g:tex_conceal='abdmg'


" UltiSnips
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'
let g:UltiSnipsJumpBackwardTrigger='<s-tab>'
let g:UltiSnipsEditSplit='vertical'

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

" =============================================================================
" # VISUAL SETTINGS
" =============================================================================

" Visual settings
syntax enable                   " Syntax highlighting for applicable buffers
set noshowmode                  " Hide -- MODE -- on bottom line
set wrap                        " Wrap long lines to next display line
set linebreak                   " Wrap between words, not within
set showmatch                   " Highlight matching paired symbol
set display+=lastline           " Always show last line of paragraph
set scrolloff=3                 " Show n lines above/below cursor when scrolling
set sidescrolloff=5             " Show n columns to sides when scrolling
set noerrorbells                " Disable error bells
set novisualbell                " Especially disable visual error bell
set background=dark             " Make Vim use the correct colors in my scheme
set t_RV=''                     " Don't query for terminal version info
set t_ut=''                     " Disable background color erase
hi clear SignColumn             " For some reason, sign column wasn't using bgcolor
hi DiffAdd     cterm=italic     ctermfg=Green    ctermbg=none
hi DiffChange  cterm=none       ctermfg=Yellow   ctermbg=none
hi DiffDelete  cterm=bold       ctermfg=Red      ctermbg=none
hi DiffText    cterm=undercurl  ctermfg=Yellow   ctermbg=none
let &t_Cs = "\e[4:3m"           " Fix undercurl behavior
let &t_Ce = "\e[4:0m"           " Fix undercurl behavior
hi ALEWarning cterm=undercurl ctermbg=none ctermul=blue
hi ALEError cterm=undercurl ctermbg=none ctermul=red
hi MatchWord cterm=underline gui=underline

" =============================================================================
" # EDITOR SETTINGS
" =============================================================================

" Functional settings
set nocompatible                " Disable vi compatibility
set encoding=utf8               " Always write utf-8 encoded files
set termencoding=utf8           " Characters appear in utf-8
scriptencoding=utf8             " Just for this file, since it has multibyte chars
set backspace=indent,eol,start  " Allow backspace across [chars]
set autoread                    " If file is changed outside vim, reload it
set autochdir                   " Ensure working directory = directory of vim
set ttyfast                     " Redraw faster
set lazyredraw                  " Don't draw screen during command execution
set undofile                    " Enable preserved histories across sessions
set undodir=~/.vim/undodir      " Store histories in specific dir instead of same as file
set mouse=a                     " Enable mouse
set ttymouse=sgr                " Change how vim understands mouse inputs
set splitbelow                  " Open :split buffers on bottom
set splitright                  " Open :vsplit buffers on right
set hidden                      " Allow hidden buffers
set ignorecase                  " No case = any case
set smartcase                   " Adding case = case sensitive
set hlsearch                    " Highlight results
set incsearch                   " Jump to nearest result as you search
set clipboard^=unnamedplus      " Use system clipboard always
filetype plugin indent on       " Autoindent+plugins per filetype

" Formatting settings
set shiftround                  " Round 'shift' to shiftwidth
set textwidth=80                " Wrap to new buffer line based on column width.
set formatoptions+=c            " Auto-formatting based on textwidth; respects comments
set formatoptions-=t
set noendofline                 " Disable automatically added newline

" Information settings
set ruler                       " Display position on statusbar
set number                      " Line numbers
set relativenumber              " Distances from cursor in line numbers
set laststatus=2                " Display statusline always
set wildmenu                    " Enable command completion after :
set wildmode=longest:full,list  " Autocomplete to longest common string
set title                       " Show vim status on title bar if applicable
set showcmd                     " Show currently typed command
set history=1000                " Preserve n changes

" Completion
set completeopt=menuone,noinsert,noselect
" Better display for messages
set cmdheight=2
" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

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

" No arrow keys --- force yourself to use the home row
nnoremap <up> <nop>
nnoremap <down> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

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
nnoremap <Leader>gb :Gblame<CR>
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

" Remember last edited location when reopening file, if valid
augroup remember_last_position
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

augroup file_settings
    autocmd FileType md,svn,*commit* setlocal spell
augroup END

" Add group from jsx
augroup FiletypeGroup
    autocmd!
    au BufNewFile,BufRead *.jsx set filetype=javascript.jsx
augroup END
