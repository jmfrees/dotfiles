" prep general vim environment
if !isdirectory($HOME.'/.vim')
    call mkdir($HOME.'/.vim', '', 0700)
endif
if !isdirectory($HOME.'/.vim/undodir')
    call mkdir($HOME.'/.vim/undodir', '', 0700)
endif

" check if remote session
let g:remoteSession = !($SSH_TTY ==? '')
if g:remoteSession
    colorscheme slate
endif

" set :term/:shell program
if filereadable('/bin/fish')
    set shell=/bin/fish\ --login
else
    set shell=/bin/bash\ --login
endif

" visual settings
syntax enable                   " syntax highlighting for applicable buffers
set noshowmode                  " hide -- MODE -- on bottom line
set wrap                        " wrap long lines to next display line
set linebreak                   " wrap between words, not within
set showmatch                   " highlight matching paired symbol
set display+=lastline           " always show last line of paragraph
set scrolloff=3                 " show n lines above/below cursor when scrolling
set sidescrolloff=5             " show n columns to sides when scrolling
set noerrorbells                " disable error bells
set novisualbell                " especially disable visual error bell
highlight clear SignColumn      " for some reason, sign column wasn't using bgcolor

" functional settings
set nocompatible                " disable vi compatibility
set foldmethod=indent           " fold based on indent level
set nofoldenable                " no fold by default
set conceallevel=3              " fold by default inside 3+ levels of [foldmethod]
set encoding=utf8               " always write utf-8 encoded files
set termencoding=utf8           " characters appear in utf-8
scriptencoding=utf8             " just for this file, since it has multibyte chars
set backspace=indent,eol,start  " allow backspace across [chars]
set autoread                    " if file is changed outside vim, reload it
set autochdir                   " ensure working directory = directory of vim
set ttyfast                     " redraw faster
set lazyredraw                  " don't draw screen during command execution
set undofile                    " enable preserved histories across sessions
set undodir=~/.vim/undodir      " store histories in specific dir instead of same as file
set mouse=a                     " enable mouse
set ttymouse=sgr                " change how vim understands mouse inputs
set splitbelow                  " Open :split buffers on bottom
set splitright                  " Open :vsplit buffers on right
set pastetoggle=<F2>            " toggle paste when pressing F2
set hidden	                    " buffers stay open+edited when not visible
set ignorecase                  " no case = any case
set smartcase                   " adding case = case sensitive
set hlsearch                    " highlight results
set incsearch                   " jump to nearest result as you search
filetype plugin indent on       " autoindent+plugins per filetype

" formatting settings
set autoindent                  " newlines inherit indent level
set smarttab                    " ... but only when sensible
set expandtab                   " replace tab with space
set tabstop=4                   " n-width tabs
set softtabstop=4               " do not enforce tab width on existing tabs
set shiftwidth=4                " when moving text with [<>], move by n
set shiftround                  " round 'shift' to shiftwidth
set textwidth=80                " wrap to new buffer line based on column width.
set formatoptions+=tc           " auto-formatting based on textwidth; respects comments
set noendofline                 " disable automatically added newline

" information settings
set ruler                       " display position on statusbar
set number                      " line numbers
set relativenumber              " distances from cursor in line numbers
set laststatus=2                " display statusline always
set wildmenu                    " enable command completion after :
set wildmode=longest:full,list  " autocomplete to longest common string
set title                       " show vim status on title bar if applicable
set showcmd                     " show currently typed command
set history=1000                " preserve n changes

" command remaps
command! W :write
command! Q :quit

" key remaps
nnoremap <SPACE> <Nop>          " disable all space bindings
map <SPACE> <Leader>            " map space to current leader (default: \)
let mapleader=' '               " map leader to space

nnoremap <silent> <CR> :noh<CR><CR>
" clear search highlight by hitting enter
" hitting n or performing another search will re-enable

" janky tab navigation in completion menus
" only remap if popup menu visible (includes hover...), else Tab
inoremap <expr> <Tab> pumvisible() ? '<Down>' : '<Tab>'

" autocommands
" remember last edited location when reopening file, if valid
augroup remember_last_position
    au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

augroup file_settings
    autocmd FileType svn,*commit* setlocal spell
    autocmd FileType c,cpp,h,hpp setlocal shiftwidth=2 tabstop=2 softtabstop=2
augroup END

" ALL PLUGIN SETTINGS
" NOTE: you can :echo glob($VIMRUNTIME . '/ftplugin/*.vim') to see filetypes available
" NOTE: you can :PlugStatus to see running plugins
call plug#begin()
    if has('timers')                    " async feature
        Plug 'dense-analysis/ale'       " linting, completion, formatting
    endif

    Plug 'vimwiki/vimwiki'
    Plug 'jpalardy/vim-slime'           " send buffer data to [session]
    Plug 'tpope/vim-fugitive'           " git information and commands
    Plug 'airblade/vim-gitgutter'       " gitlens for vim
    Plug 'vim-airline/vim-airline'      " fancy status bar
    Plug 'preservim/nerdtree'           " file explorer inside vim
    Plug 'Xuyuanp/nerdtree-git-plugin'  " symbols based on git status
    Plug 'ryanoasis/vim-devicons'       " fancy symbols integration

    if !g:remoteSession
        Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
        Plug 'lervag/vimtex', {'for': ['tex', 'plaintex']}        " LaTeX previewer, \ll to start
        Plug 'sirver/ultisnips', {'for': ['tex', 'plaintex']}     " faster snippets completion
    endif
call plug#end()

nnoremap <silent> <C-k> <Plug>(ale_previous_wrap)   " jump to errors
nnoremap <silent> <C-j> <Plug>(ale_next_wrap)

" remaps for plugins
nnoremap <C-n> :NERDTreeToggle<CR>

nmap <leader>1 <Plug>AirlineSelectTab1      " i3-style buffer selection
nmap <leader>2 <Plug>AirlineSelectTab2      " better than :b
nmap <leader>3 <Plug>AirlineSelectTab3      " airline ignores special buffers
nmap <leader>4 <Plug>AirlineSelectTab4      " like :help and NERDTree
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>- <Plug>AirlineSelectPrevTab
nmap <leader>+ <Plug>AirlineSelectNextTab

nmap <silent> <C-s> <Plug>MarkdownPreview           " toggle markdown preview

" autocommands for plugins
augroup open_nerdtree_if_no_args_session
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" | NERDTreeToggle | endif
augroup END

" ALE
let g:ale_completion_enabled = 1
let g:ale_completion_autoimport = 1
let g:ale_lint_delay = 750
let g:ale_completion_delay = 100
let g:ale_fix_on_save = 1
let g:ale_set_balloons = 1
let g:ale_echo_msg_info_str = '🛈 '
let g:ale_echo_msg_warning_str = '⚠ '
let g:ale_echo_msg_error_str = '❌'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
let g:ale_linters = {
                \   'c': ['cc', 'clangtidy', 'clangd'],
                \   'cpp': ['cc', 'clangtidy', 'clangd'],
                \   'css': ['prettier'],
                \   'dockerfile': ['hadolint'],
                \   'java': ['javac', 'eclipselsp'],
                \   'javascript': ['eslint', 'tsserver'],
                \   'json': ['jsonlint'],
                \   'markdown': ['alex', 'proselint'],
                \   'vimwiki': ['alex', 'proselint'],
                \   'python': ['bandit', 'flake8', 'pylint', 'pyls'],
                \   'rust': ['cargo', 'rls'],
                \   'sh': ['shell', 'shellcheck', 'language_server'],
                \   'sql': ['sqlint', 'sql-language-server'],
                \   'vim': ['vint', 'vimls'],
                \   'yaml': ['yamllint'],
                \   }
let g:ale_fixers =  {
                \   '*': ['remove_trailing_lines', 'trim_whitespace'],
                \   'c': ['clang-format'],
                \   'cpp': ['clang-format'],
                \   'css': ['prettier'],
                \   'dockerfile': [],
                \   'java': ['google_java_format'],
                \   'javascript': ['eslint', 'prettier'],
                \   'json': ['prettier'],
                \   'markdown': ['prettier'],
                \   'python': ['isort', 'black'],
                \   'rust': ['rustfmt'],
                \   'sh': ['shfmt'],
                \   'sql': ['pgformatter'],
                \   'vim': ['remove_trailing_lines', 'trim_whitespace'],
                \   'yaml': ['prettier'],
                \   }
let g:ale_python_pyls_config = {'pyls': {'plugins': {'pycodestyle': {'enabled': v:false}}}}
command! ALEToggleFixer execute "let g:ale_fix_on_save = get(g:, 'ale_fix_on_save', 0) ? 0 : 1"

" vimwiki
let g:vimwiki_list = [{'path': '~/.vimwiki', 'path_html': '~/public_html'}]

" vim-slime
let g:slime_target = 'vimterminal'                  " session to send to
let g:slime_paste_file = '$HOME/.vim/.slime_paste'  " cleaner selection for paste file
let g:slime_python_ipython = 1                      " ipython drops inputs without this

" NERDTree
let g:NERDTreeShowHidden=1
let g:NERDTreeShowLineNumbers=1
let g:NERDTreeNaturalSort=1

" airline
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_powerline_fonts = 1               " fancy unicode symbols
let g:airline_left_sep = ''                     " omit for cleanliness
let g:airline_right_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.crypt = '🔐'              " encrypted file
let g:airline_symbols.readonly = '🔒'           " read only file
let g:airline_symbols.linenr = '¶'              " linenum
let g:airline_symbols.maxlinenr = ''            " column num
let g:airline_symbols.paste = '∥'               " paste mode
let g:airline_symbols.spell = '✓'               " spell mode
let g:airline_symbols.dirty='*'                 " dirty git buffer
let g:airline_symbols.notexists = 'Ɇ'

let g:airline#extensions#tabline#enabled = 1                " display open buffers+tabs on top bar
let g:airline#extensions#tabline#buffer_nr_show = 1         " show buffer # on tabline
let g:airline#extensions#tabline#nametruncate = 16          " max buffer name of 16 chars
let g:airline#extensions#tabline#fnamecollapse = 2          " only show 2 trunc'd parent dirs
let g:airline#extensions#branch#displayed_head_limit = 16   " limit branch names to first 16 chars

" markdown-preview.nvim
let g:mkdp_browser = 'firefox'

" vimtex
let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_view_general_viewer = 'zathura'
let g:vimtex_compiler_progname = 'tectonic'
let g:tex_conceal='abdmg'

" UltiSnips
let g:UltiSnipsExpandTrigger = '<C-c>'      " TODO: could be comfier
let g:UltiSnipsJumpForwardTrigger = '<C-b>'
let g:UltiSnipsJumpBackwardTrigger = '<C-z>'
