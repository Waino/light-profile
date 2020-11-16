" my custom vimrc...

set nocompatible        " Be incompatible with vi, please

" comment out if unsuitable
set termencoding=utf-8
set t_Co=256

"################## BASIC ####################
"set tabstop=8		    " Python has made me change my mind about this
set autoindent
set smartindent		    " cindent (cindent does a bit more)
			            " Don't make a # force column zero.
inoremap # X<BS>#
set backspace=2		    " Allow backspacing outside the current insertion 2=indent,eol,start
set scrolloff=3         " Keep 3 lines above and below cursor
set showmatch           " Show matching delimiters
set showmode            " Show current input mode in status line
set cinoptions=:0,p0,t0,(1s                         " C language indent options
set tags=./tags,tags,../tags,mapper/java/tags       " Tags file search path
set dictionary=/usr/dict/words                      " Dictionary file path
set lazyredraw
set mousehide
set ruler               " show cursor all the time
set nobackup
set writebackup		    " nobackup + writebackup: backup current file, deleted afterwards
set title
set sc                  " show commands
set nojoinspaces        " dont double spaces when joining with J
" set bf        	    " to remove non-beautiful chars
"set wildmode=list:longest
set wildmenu				" tab-cycling visible menu of alternatives
set wildmode=longest:full,full		" complete as far as possible

"Why I ever want to open one of these?
set wildignore+=*.o,*.class,*~,CVS,*.gz,*.Z,*.tar

"what may cause a line break
set brk=\ \	!@*-+_;:,./?
set linebreak

set wrapmargin=0
set textwidth=0
set wrap

"set fileencoding=latin-1
set fileencoding=utf-8

" ################### SEARCHING ###############
set ic		" Ignore case when searching
set scs		" but override if using upper case (smart case)
set ws		" search wraps round
set incsearch   " show search matches while typing

" ############# Automatic mode switching #######
" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
  "set lines=25
endif
filetype on

" How to show tabs and trailing whitespace visually, when :set list used
if v:version >= 700
  set listchars=tab:>_,trail:.,extends:>,nbsp:_
else
  set listchars=tab:>_,trail:.,extends:>
endif

" ### mappings ###
" i use , as prefix to own navigation commands

"map ,n :bN!<cr>
"map ,p :bprev!<cr>
"map ,sn :sbnext<cr>
"map ,sp :sbprev<cr>
"map ,d :bdelete<cr>
"map ,fd :bdelete!
"map ,l :buffers<cr>

" I never use K except by accident
vmap K k
" I never use q: except by accident
nmap q: :q

" toggle paste mode
:map ,p :set invpaste<CR>:set expandtab<CR>

" ### functions ###
" enable line numbers and whitespace markings
map ,g :cal Guides()<CR>
let g:guides = 0
fun! Guides()
  if g:guides == 1
    let g:guides = 0
    set nonumber nolist
  else
    let g:guides = 1
    set number list
  endif
endfun

" begin and end tags of LaTeX environment
map ,b :cal LatexEnv()<CR>
fun! LatexEnv()
  :s/\(.*\)/\\begin{\1}\r\\end{\1}/
  :noh
  :normal k
  :normal o
endfun

" turn plaintext bullet list to LaTeX
map ,l :normal ^[<CR>:cal LatexItemize()<CR>
fun! LatexItemize()
  :silent '<,'>s/^\(\s*\)\(- \)\?\(\\item \)\?/\1\\item /
  :'<
  :normal O\begin{itemize}
  :'>
  :normal o\end{itemize}
  :'<,'>>
endfun

" insert a LaTeX table
map ,t :normal ^[<CR>:cal LatexTable()<CR>
fun! LatexTable()
  :s/\(.*\)/\\begin{table*}\r\\begin{center}\r\\begin{tabular}{}\r\\toprule\r\\midrule\r\\bottomrule\r\\end{tabular}\r\\caption{\r    \\label{tab:\1}}\r\\end{center}\r\\end{table*}/
  :noh
endfun


" helper
function! s:get_visual_selection()
  " Why is this not a built-in Vim script function?!
  let [lnum1, col1] = getpos("'<")[1:2]
  let [lnum2, col2] = getpos("'>")[1:2]
  let lines = getline(lnum1, lnum2)
  let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
  let lines[0] = lines[0][col1 - 1:]
  return join(lines, "\n")
endfunction

" Java getter from field def
fun! Jget()
  :normal YP
  :s/private\|protected /public
  :s/;/() {
  :s/\(\w*()\)/get\u\1
  :+1
  :s/private \w* /	return this./
  :normal o}
endfun

" Silly helper to un-decode my article-pdf name format
fun! PaperToSearch()
  :normal Yp
  :s/_-_/ /
  :s/\.pdf//
  :s/_/ /g
  :s/\([a-z]\)\([A-Z]\)/\1 \2/g
endfun

fun! SettingsUnPython()
  "set textwidth=79
  set shiftwidth=16
  set tabstop=16
  set noexpandtab
  set softtabstop=0
  set noshiftround
endfun

fun! SettingsPython()
  set tabstop=4
endfun

fun! SyntasticOn()
  let g:syntastic_check_on_open = 1
  let g:syntastic_mode_map = {"mode": "active"}
  call SyntasticCheck()
endfun

" strips trailing whitespace at the end of files. this
" is called on buffer write in the autogroup above.
function! StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

set shiftwidth=4
set tabstop=4
set expandtab
set softtabstop=4
set shiftround

" ### plugin settings
" # vim-closetags
let g:closetag_filenames = "*.html,*.xhtml,*.xml"
" # syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" syntastic takes over location list (instead of manual :Errors )
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
" off by default:
" dont check when opening and writing buffers, or write-and-quit
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = {
    \ "mode": "passive",
    \ "active_filetypes": [],
    \ "passive_filetypes": [] }
" aggregates errors from multiple checker programs
let g:syntastic_aggregate_errors = 1
let g:syntastic_python_checkers = ['pylint', 'pep8']
" ignore verbose errors in pylint
let g:syntastic_python_pylint_args="--disable=bad-whitespace,import-error,invalid-name,maybe-no-member,missing-docstring,no-init,no-member,no-self-use,star-args,superfluous-parens,too-few-public-methods,too-many-arguments,too-many-instance-attributes,too-many-lines,too-many-locals,too-many-statements"
" ignore alignment multi-space in pep8
" ignore under-indented for visual indent
let g:syntastic_python_pep8_args="--ignore=E2,E128"
" style errors with warning-yellow instead of error-red
hi SyntasticStyleErrorSign ctermfg=black ctermbg=yellow

" # jedi-vim
" don't open docstring during completion
autocmd FileType python setlocal completeopt-=preview
" don't open popup immediately after dot
let g:jedi#popup_on_dot = 0
" call signature in command window instead of overlay
let g:jedi#show_call_signatures = 2
" # vim-ipython (reminder: start with 'ipython kernel', then ':IPython'
" control-S is a stupid binding
xmap <buffer> <silent> <C-E>          <Plug>(IPython-RunLines)

" autocommands
if !exists("autocommands_loaded")
  let autocommands_loaded = 1
  augroup filetype
    "clear the group
    au!  
    " make .inc files syntaxhilight as php code
    au BufRead,BufNewFile *.inc    set filetype=php
    " .as as java (this is not quite correct, but in the right direction)
    au BufRead,BufNewFile *.as     set filetype=java
    " For help files, move them to the top window and make <Return>
    au FileType help nmap <buffer> <Return> <C-]>
    " files that cant handle python settings
    au BufRead,BufNewFile Makefile     call SettingsUnPython()
    au BufRead,BufNewFile *.tsv     call SettingsUnPython()
    " textwidth for mail editing
    au BufRead,BufNewFile /tmp/mutt-*   set textwidth=75
    " I don't edit plaintex
    au BufNewFile,BufRead *.tex set syntax=tex
    " Snakefiles for snakemake
    au BufNewFile,BufRead Snakefile set syntax=snakemake
    au BufNewFile,BufRead *.snake set syntax=snakemake
  augroup END
endif

set background=dark
"
" Then lets have proper colors in gui
hi comment guifg=blue
hi Constant guifg=Magenta
hi Special guifg=SlateBlue
hi identifier guifg=darkcyan
hi Statement guifg=brown
hi preProc guifg=Purple
hi type guifg=SeaGreen
hi error guifg=white guibg=red
hi todo guifg=blue guibg=yellow
"
" And better colors in terminal
" search should  should be black on yellow
hi Search ctermbg=11 ctermfg=4
" and comment should be gray (blue is too invisible)
"hi Comment ctermfg=8
hi Comment ctermfg=246
" For some reason needed at work for visualizing selection
hi Visual cterm=reverse   ctermbg=none
