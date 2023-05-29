" neil killeen

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                preamble                                 "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if filereadable('/usr/local/bin/zsh')
  set shell=/usr/local/bin/zsh\ --rcs
endif

if has('nvim')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
endif

set encoding=utf-8

set nocompatible
filetype off

if filereadable($HOME.'/.pyenv/versions/neovim2/bin/python')
  let g:python_host_prog = $HOME.'/.pyenv/versions/neovim2/bin/python'
endif
if filereadable($HOME.'/.pyenv/versions/neovim3/bin/python')
  let g:python3_host_prog = $HOME.'/.pyenv/versions/neovim3/bin/python'
endif
let g:vimspector_enable_mappings = 'HUMAN'

packadd minpac
call minpac#init()

call minpac#add('lifepillar/vim-solarized8')
call minpac#add('altercation/vim-colors-solarized')
call minpac#add('preservim/tagbar')
call minpac#add('tpope/vim-fugitive')
call minpac#add('tpope/vim-repeat')
call minpac#add('tpope/vim-vinegar')
call minpac#add('tpope/vim-bundler')
call minpac#add('tpope/vim-projectionist')
call minpac#add('tpope/vim-surround')
call minpac#add('tpope/vim-haml')
call minpac#add('tpope/vim-rails')
call minpac#add('tpope/vim-dispatch')
call minpac#add('tpope/vim-unimpaired')
call minpac#add('junegunn/fzf', { 'dir': '~/.fzf', 'do': {-> system('./install --all')} })
call minpac#add('junegunn/fzf.vim')
call minpac#add('scrooloose/nerdtree')
call minpac#add('vim-ruby/vim-ruby')
call minpac#add('leafgarland/typescript-vim')
call minpac#add('jremmen/vim-ripgrep')
call minpac#add('HerringtonDarkholme/yats.vim')
call minpac#add('SirVer/ultisnips')
call minpac#add('honza/vim-snippets')
call minpac#add('ycm-core/YouCompleteMe', { 'do': {-> system('python3 install.py --all')} })
call minpac#add('puremourning/vimspector')
"call minpac#add('mfussenegger/nvim-dap') " Another debug adapter to try someday

command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
command! PackStatus packadd minpac | source $MYVIMRC | call minpac#status()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                           reset vimrc augroup                           "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" We reset the vimrc augroup. Autocommands are added to this group throughout
" the file
"augroup vimrc
"  autocmd!
"  " Return to last edit position when opening files (You want this!)
"  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
"  " Source the vimrc file after saving it
"  autocmd bufwritepost vimrc source $MYVIMRC
"  " Stop that dumb autocommenting
"  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
"  autocmd vimrc GUIEnter * set visualbell t_vb=
"augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                        turn on filetype plugins                         "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable detection, plugins and indenting in one step
" This needs to come AFTER the call minpac#add('commands!
filetype plugin indent on
syntax on
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                            General settings                             "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" DISPLAY SETTINGS
set background=dark
set scrolloff=7         " 2 lines above/below cursor when scrolling
set showmatch           " show matching bracket (briefly jump)
set matchtime=2         " reduces matching paren blink time from the 5[00]ms def
set showmode            " show mode in status bar (insert/replace/...)
set showcmd             " show typed command in status bar
set ruler               " show cursor position in status bar
set title               " show file in titlebar
set undofile            " stores undo state even when files are closed (in undodir)
set cursorline          " highlights the current line
set winaltkeys=no       " turns of the Alt key bindings to the gui menu
set number              " show line numbers
set norelativenumber    " show line numbers absolute
set guifont=PragmataPro:h14

" When you type the first tab, it will complete as much as possible, the second
" tab hit will provide a list, the third and subsequent tabs will cycle through
" completion options so you can complete the file without further keys
set wildmode=longest,list,full
set wildmenu            " completion with menu
set wildignore+=*/build/*,*.rar,*.zip,*.jar,*.min.js,*.git,*.class,.git

" This changes the default display of tab and CR chars in list mode
set listchars=tab:▸\ ,eol:¬

" The "longest" option makes completion insert the longest prefix of all
" the possible matches; see :h completeopt
set completeopt=menu,menuone,longest
set switchbuf=useopen,usetab

" EDITOR SETTINGS
set ignorecase          " case insensitive searching
set smartcase           " but become case sensitive if you type uppercase characters
" this can cause problems with other filetypes
" see comment on this SO question http://stackoverflow.com/questions/234564/tab-key-4-spaces-and-auto-indent-after-curly-braces-in-vim/234578#234578
"set smartindent         " smart auto indenting
set autoindent          " on new lines, match indent of previous line
set copyindent          " copy the previous indentation on autoindenting
set cindent             " smart indenting for c-like code
set cino=b1,g0,N-s,t0,(0,W4  " see :h cinoptions-values
set smarttab            " smart tab handling for indenting
set magic               " change the way backslashes are used in search patterns
set bs=indent,eol,start " Allow backspacing over everything in insert mode
set nobackup            " no backup~ files.

set tabstop=2           " number of spaces a tab counts for
set shiftwidth=2        " spaces for autoindents
set softtabstop=2
set shiftround          " makes indenting a multiple of shiftwidth
set expandtab           " turn a tab into spaces
set laststatus=2        " the statusline is now always shown
set noshowmode          " don't show the mode ("-- INSERT --") at the bottom

" misc settings
set fileformat=unix     " file mode is unix
set fileformats=unix,dos,mac   " detects unix, dos, mac file formats in that order
set sessionoptions-=options    " removes local options from session saves

set viminfo='20,\"500   " remember copy registers after quitting in the .viminfo
                        " file -- 20 jump links, regs up to 500 lines'
set hidden              " allows making buffers hidden even with unsaved changes
set history=1000        " remember more commands and search history
set undolevels=1000     " use many levels of undo
set autoread            " auto read when a file is changed from the outside
set mouse=a             " enables the mouse in all modes
set foldlevelstart=99   " all folds open by default
set ttimeoutlen=100     " timeout for a keycode delay (speeds up esc + shift + o)

" toggles vim's paste mode; when we want to paste something into vim from a
" different application, turning on paste mode prevents the insertion of extra
" whitespace
set pastetoggle=<F7>

" Right-click on selection should bring up a menu
set mousemodel=popup_setpos

" With this, the gui (gvim and macvim) now doesn't have the toolbar, the left
" and right scrollbars and the menu.
set guioptions-=T
set guioptions-=l
set guioptions-=L
set guioptions-=r
set guioptions-=R
set guioptions-=m
set guioptions-=M

" this makes sure that shell scripts are highlighted
" as bash scripts and not sh scripts
let g:is_posix = 1

" tries to avoid those annoying "hit enter to continue" messages
" if it still doesn't help with certain commands, add a second <cr>
" at the end of the map command
set shortmess=ac

" this solves the "unable to open swap file" errors on Win7
set dir=~/tmp,/var/tmp,/tmp,$TEMP
set undodir=~/tmp,/var/tmp,/tmp,$TEMP

" Look for tag def in a "tags" file in the dir of the current file, then for
" that same file in every folder above the folder of the current file, until the
" root.
set tags=libraries/tags,tags,../node_modules/tags
map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>
nnoremap <c-tab> :tabn<CR>

" turns off all error bells, visual or otherwise
set noerrorbells visualbell t_vb=

" Switch syntax highlighting on, when the terminal has colors
if &t_Co > 2 || has("gui_running")
  syntax enable
endif

" none of these should be word dividers, so make them not be
set iskeyword+=_,$,@,%,#

" Number of screen lines to use for the command-line
set cmdheight=2

" allow backspace and cursor keys to cross line boundaries
set whichwrap+=<,>,h,l
set nohlsearch          " do not highlight searched-for phrases
set incsearch           " ...but do highlight-as-I-type the search string
set gdefault            " this makes search/replace global by default

" enforces a specified line-length and auto inserts hard line breaks when we
" reach the limit; in Normal mode, you can reformat the current paragraph with
" gqap.
set textwidth=0
set wrapmargin=0

" this makes the color after the textwidth column highlighted
set colorcolumn=+1

" options for formatting text; see :h formatoptions
set formatoptions=tcroqnj

set clipboard=unnamed

" Relative paths in insert mode
"augroup relative_paths
"  autocmd!
"  autocmd InsertEnter * let save_cwd = getcwd() | setlocal autochdir
"  autocmd InsertLeave * setlocal noautochdir | execute 'cd' fnameescape(save_cwd)
"augroup END

" Terminal config
if has('nvim')
  au TermOpen * tnoremap <buffer> <Esc> <C-\><C-n>
  au FileType fzf tunmap <buffer> <Esc>
  tnoremap <M-[> <Esc>
  tnoremap <C-v><Esc> <Esc>
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                            custom mappings                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>[ :diffget //2<CR>
nnoremap <leader>] :diffget //3<CR>
nnoremap <leader>w :%s/\s\+$//<CR>

map <c-w>t :$tabedit <c-r>%<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       ***  HERE BE PLUGINS  ***                         "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                Solarized                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"let g:solarized_visibility="high"
"let g:solarized_termcolors=16
"let g:solarized_contrast="high"
"let g:solarized_termtrans=1
"let g:solarized_hitrail=1
"colorscheme solarized
let g:solarized_use16=1
colorscheme solarized8

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                              YouCompleteMe                              "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ycm_always_populate_location_list = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_min_num_identifier_candidate_chars = 1
let g:ycm_filetype_specific_completion_to_disable = {'javascript': 1}
let g:ycm_collect_identifiers_for_tags_file = 1
let g:ycm_disable_for_files_larger_than_kb = 0
if executable('which') && !empty(trim(system('which brew'))) && !empty(trim(system('brew --prefix openjdk@17')))
  let g:ycm_java_binary_path = trim(system('brew --prefix openjdk@17')).'/bin/java'
elseif executable('readlink') && executable('update-alternatives') && executable('grep') && executable('awk')
  let g:ycm_java_binary_path = trim(system('readlink -f $(update-alternatives --query java | grep "Value: " | awk \'{print $2}\')'))
endif

nnoremap <leader>y :<C-u>YcmForceCompileAndDiagnostics<CR>
nnoremap <leader>i :<C-u>YcmCompleter OrganizeImports<CR>
nnoremap <leader>f :<C-u>YcmCompleter FixIt<CR>
nnoremap <leader>r :<C-u>YcmCompleter RefactorRename 
nnoremap <leader>d :<C-u>YcmCompleter GetDoc<CR>
nnoremap <M-]> :<C-u>YcmCompleter GoTo<CR>
nnoremap <C-M-]> :<C-u>YcmCompleter GoToReferences<CR>

" YouCompleteMe custom Java and JDTLS config
"
"let g:ycm_java_jdtls_workspace_root_path='/Users/nkilleen/eclipse-workspace'
"let g:ycm_java_jdtls_use_clean_workspace=0
"let g:ycm_java_binary_path='/Library/Java/JavaVirtualMachines/jdk-11.0.2.jdk/Contents/Home/bin/'


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                  Rg                                     "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nnoremap <leader>g :<C-u>Rg '' -t %:e<Left><Left><Left><Left><Left><Left><Left><Left>
nnoremap <leader>h :<C-u>Rg '<c-r>=expand("<cword>")<cr>' -t %:e<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                tagbar                                   "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"let g:tagbar_left = 1
"let g:tagbar_sort = 0
"let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
"
"nnoremap <F4> :TagbarToggle<cr><c-w>=

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                ack.vim                                  "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if executable('ag')
  let g:ackprg = "ag --vimgrep"
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                go-vim                                   "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"au vimrc FileType go nmap <Leader>gs <Plug>(go-implements)
"au vimrc FileType go nmap <Leader>gi <Plug>(go-info)
"au vimrc FileType go nmap <Leader>gd <Plug>(go-doc) 
"au vimrc FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
"au vimrc FileType go nmap <Leader>gb <Plug>(go-doc-browser)
"au vimrc FileType go nmap <leader>gr <Plug>(go-run)
"au vimrc FileType go nmap <leader>gb <Plug>(go-build)
"au vimrc FileType go nmap <leader>gt <Plug>(go-test)
"au vimrc FileType go nmap <leader>gc <Plug>(go-coverage)
"au vimrc FileType go nmap <leader>gd <Plug>(go-def)
"au vimrc FileType go nmap <Leader>ds <Plug>(go-def-split)
"au vimrc FileType go nmap <Leader>dv <Plug>(go-def-vertical)
"au vimrc FileType go nmap <Leader>dt <Plug>(go-def-tab)
"au vimrc FileType go nmap <Leader>ge <Plug>(go-rename)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                                UltiSnips                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" we can't use <tab> as our snippet key since we use that with YouCompleteMe
let g:UltiSnipsExpandTrigger       = "<c-d>"
let g:UltiSnipsJumpForwardTrigger  = "<c-s>"
let g:UltiSnipsJumpBackwardTrigger = "<c-a>"
let g:snips_author                 = 'Neil Killeen'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             NumberToggle                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:NumberToggleTrigger="<F2>"

" FZF
nnoremap <silent> <C-p> :<C-u>Files<CR>
nnoremap <silent> <A-p> :<C-u>Buffers<CR>
nnoremap <silent> <A-o> :<C-u>Tags<CR>
let g:fzf_buffers_jump = 1

" TagBar
" <M-tab> defaults to TagbarToggle
nnoremap <C-tab> :<C-u>TagbarToggle<CR>

"Rg
let g:rg_command = 'rg --color=never --glob "!*.jar" --glob "!**/*.jar" --glob "!sources" --glob "!tags" --vimgrep'

" Visual effects
set lazyredraw
augroup cursor_line
  autocmd!
  autocmd InsertEnter * set cul
  autocmd InsertLeave * set nocul
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             Custom Binds                                "
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"Fugitive
nnoremap <leader>s :Git<CR>

"NERDTree

nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <M-n> :NERDTreeFind<CR>

"Airline

let g:airline#extensions#tabline#enabled = 1
let g:airline_left_sep = ""
let g:airline_right_sep = ""
let g:airline#extensions#tabline#left_sep = ""
let g:airline_theme = "dark"

"Java

"Ruby
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 1
let g:rubycomplete_rails = 1
let g:rubycomplete_load_gemfile = 1

"typescript
let g:typescript_compiler_binary = 'tsc'
let g:typescript_compiler_options = ''
let g:typescript_indent_disable = 1

augroup formatting
  autocmd!
  autocmd Filetype java setlocal ts=3 sts=3 sw=3
  autocmd Filetype ruby setlocal ts=2 sts=2 sw=2
augroup END

augroup makeprograms
  autocmd!
  autocmd FileType ruby setlocal makeprg=bin/rake
  autocmd FileType typescript setlocal makeprg=tsc
  autocmd FileType java setlocal makeprg=$(git\ rev-parse\ --show-toplevel)/gradlew\ $*
augroup END

augroup gradle
  autocmd!
  "Version 1: Requires one to specify the project within the current working directory
  "command! -nargs=? TF split | te gradlew :<args>:test --tests "%:t:r*"
  "Version 2: Uses the current file to determine the closest parent project
  command! TestFile split | execute "make test --project-dir " . fnamemodify(getcwd() . "/" . findfile('build.gradle', '.;'), ':p:h') . " --tests \"%:t:r*\""
  command! TF TestFile
  command! TestProject split | execute "make test --project-dir " . fnamemodify(getcwd() . "/" . findfile('build.gradle', '.;'), ':p:h')
  command! TP TestProject
  command! BuildProject split | execute "make build --project-dir " . fnamemodify(getcwd() . "/" . findfile('build.gradle', '.;'), ':p:h')
  command! BP BuildProject
augroup END

function s:createJavaTest()
  if expand("%:e") == "java"
    let currentDirectory = expand("%:p:h")
    let currentFileNameWithoutExtension = expand("%:t:r")
    let destinationDirectory = substitute(currentDirectory, "\/src\/main", "\/src\/test", "g")
    call mkdir(destinationDirectory, "p")
    execute "vsplit | edit " . destinationDirectory . "/" . currentFileNameWithoutExtension . "Test.java"
  else
    echoerr "Can only create a test for java files."
  endif 
endfunction

augroup createJavaTest
  autocmd!
  autocmd FileType java command! TestCreate call s:createJavaTest()
  autocmd FileType java command! TC TestCreate
  autocmd FileType java command! TestEdit TestCreate
  autocmd FileType java command! TE TestCreate
augroup END

" nvr :wq deletes buffer
autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

" mnemonic 'di' = 'debug inspect' (pick your own, if you prefer!)

" for normal mode - the word under the cursor
nmap <Leader>di <Plug>VimspectorBalloonEval
" for visual mode, the visually selected text
xmap <Leader>di <Plug>VimspectorBalloonEval
nmap <LocalLeader><F11> <Plug>VimspectorUpFrame
nmap <LocalLeader><F12> <Plug>VimspectorDownFrame
nmap <LocalLeader>B     <Plug>VimspectorBreakpoints
nmap <LocalLeader>D     <Plug>VimspectorDisassemble
