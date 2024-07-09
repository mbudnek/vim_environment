" Load pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim

" These have to be here before I call pathogen#infect so that they're
" visible when their corresponding plugin loads.

" Suppress easytags warning about ctags not being installed
" It's really annoying, and I don't really need easytags everywhere
let g:easytags_suppress_ctags_warning = 1

" Move CoC data directory into vim home directory
let g:coc_data_home=join([split(&rtp, ',')[0], '/coc'], '')

call pathogen#infect()

function HaveX11()
    return $DISPLAY != ''
endfunction

if HaveX11() || has('mac')
    set mouse=a
endif

" Tabs
" Use a 5 space tab character and 4 space soft tabs to easily tell when tabs
" and spaces are mixed
set tabstop=5
set softtabstop=4
set shiftwidth=4
set expandtab

function Go_Tabs()
    set noexpandtab
    set tabstop=4
    set softtabstop=5
endfunction
autocmd BufNewFile,BufRead *.go call Go_Tabs()

function Java_Tabs()
    set tabstop=3
    set softtabstop=2
    set shiftwidth=2
endfunction
autocmd BufNewFile,BufRead *.java call Java_Tabs()

set backspace=indent,eol,start

" cindent params
" these more-or-less match the google C++ style guide
" L0  - Do not de-indent goto labels
" g0  - Do not indent C++ access specifiers
" N-s - Indent by siftwidth less inside C++ namespaces.
"       In other words, do not indent inside namespaces.
" :0  - Do not indent case labels in switch statements
" (0  - Do not do extra indenting on newlines within unclosed parenthesis
" Ws  - Indent by shiftwidth on newlines if an unclosed parenthisis is the last
"       character on the preceding line
set cinoptions+=L0g0N-s:0(0Ws

" Add protobuf filetype
au BufNewFile,BufRead *.proto setf proto

" basic options
syntax on
filetype plugin on
filetype indent on
set ruler
set hlsearch
set wildmenu
set wildmode=list:longest
let &directory=join([split(&rtp, ',')[0], '/tmp'], '')

" matchit isn't always available
try
    packadd! matchit
    function! Add_if_else_if_if_to_match_words()
        if &filetype ==? 'c' || &filetype ==? 'cpp' || &filetype==? 'java'
            let s:notelse = '\%(\<else\>\s\+\)\@<!'
            let s:notif = '\%(\s\+\<if\>\)\@!'
            if !exists('b:match_words')
                let b:match_words = ''
            endif
            let b:match_words = b:match_words . ',' . s:notelse . '\<if\>:\<else\s\+if\>:\<else\>' . s:notif
        endif
    endfun
    autocmd BufNewFile,BufRead * call Add_if_else_if_if_to_match_words()
catch
endtry

" clipboard stuff
set clipboard=unnamed,unnamedplus
" Don't enable autoselect on windows and mac since they only have one clipboard
" and thus autoselect prevents pasting over selected text since
" the selected text will automatically replace the current clipboard contents
if !has('win32') && !has('win32unix') && !has('mac')
    set clipboard+=autoselect
endif
" attempt to write the contents of vim's yank buffer to the clipboard on quit
function! Write_clipboard()
    if len(getreg('+')) > 0
        call system('xclip -i -selection clipboard', getreg('+'))
    endif
endfun
function! Sync_clipboard_to_selection()
    if exists(@*)
        setreg('*', getreg('+'))
    endif
endfun
if !has('win32') && !has('mac')
    autocmd VimLeave * call Write_clipboard()
endif
noremap <silent> dd dd:call Sync_clipboard_to_selection()<CR>
noremap <silent> yy yy:call Sync_clipboard_to_selection()<CR>

" Make d copy text to the 0 register like yank does by default
" Make p paste from the 0 register
" This makes it so that pasting over text in visual mode doesn't make the next
" paste operation paste the text that was pasted over
" noremap <silent> p "0p
" noremap <silent> P "0P
" noremap <silent> d d:let @0=@"<cr>

if has("gui_running")
    set lines=70 columns=120 linespace=0
    if has("gui_win32")
        set guifont=DejaVuSansMono_NF:h10
    else
        set guifont=DejaVu\ Sans\ Mono\ 10
    endif
endif

" Colors
if has('win32')
    set termguicolors
endif
set bg&
hi clear
hi clear Normal
hi clear Visual
hi Normal       guifg=LightGrey guibg=#1D1F21
hi SpecialKey   term=bold ctermfg=DarkBlue guifg=#6699CC
hi NonText      term=bold cterm=bold ctermfg=DarkBlue gui=bold guifg=#6699CC
hi Directory    term=bold ctermfg=DarkBlue guifg=#6699CC
hi ErrorMsg     term=standout cterm=bold ctermfg=Grey ctermbg=DarkRed guifg=White guibg=Red
hi IncSearch    term=reverse cterm=reverse gui=reverse
hi Search       term=reverse ctermfg=Black ctermbg=Yellow guibg=#CCCC64
hi MoreMsg      term=bold ctermfg=DarkGreen gui=bold guifg=SeaGreen
hi ModeMsg      term=bold cterm=bold gui=bold
hi LineNr       term=underline ctermfg=Yellow guifg=#CCCC64
hi CursorLineNr term=bold ctermfg=Yellow gui=bold guifg=#CCCC64
hi Question     term=standout ctermfg=DarkGreen gui=bold guifg=SeaGreen
hi StatusLine   term=bold,reverse cterm=bold,reverse gui=bold,reverse
hi StatusLineNC term=reverse cterm=reverse gui=reverse
hi VertSplit    term=reverse cterm=reverse gui=reverse
hi Title        term=bold ctermfg=DarkMagenta gui=bold guifg=Magenta
hi Visual       term=reverse cterm=reverse guibg=LightGrey
hi VisualNOS    term=bold,underline cterm=bold,underline gui=bold,underline
hi WarningMsg   term=standout ctermfg=DarkRed guifg=Red
hi WildMenu     term=standout ctermfg=Black ctermbg=Yellow guifg=Black guibg=#CCCC64
hi Folded       term=standout ctermfg=DarkBlue ctermbg=Grey guifg=DarkBlue guibg=LightGrey
hi FoldColumn   term=standout ctermfg=DarkBlue ctermbg=Grey guifg=DarkBlue guibg=Grey
hi DiffAdd      term=bold ctermbg=Black guibg=#073642
hi DiffChange   term=bold ctermbg=Black guibg=#073642
hi DiffDelete   term=bold ctermbg=Black guifg=#6699CC guibg=#073642
hi DiffText     term=reverse ctermbg=DarkRed gui=bold guibg=Red
hi SignColumn   term=standout ctermfg=DarkBlue ctermbg=Grey guifg=DarkBlue guibg=Grey
hi Conceal      ctermfg=Grey ctermbg=Black guifg=LightGrey guibg=DarkGrey
hi SpellBad     term=reverse ctermbg=DarkRed gui=undercurl guisp=Red
hi SpellCap     term=reverse ctermbg=DarkBlue gui=undercurl guisp=Blue
hi SpellRare    term=reverse ctermbg=DarkMagenta gui=undercurl guisp=Magenta
hi SpellLocal   term=underline ctermbg=DarkCyan gui=undercurl guisp=DarkCyan
hi Pmenu        ctermfg=Black ctermbg=DarkMagenta guibg=LightMagenta
hi PmenuSel     ctermfg=Black ctermbg=Grey guibg=Grey
hi PmenuSbar    ctermbg=Grey guibg=Grey
hi PmenuThumb   ctermbg=Black guibg=Black
hi TabLine      term=underline cterm=underline ctermfg=Black ctermbg=Grey gui=underline guibg=LightGrey
hi TabLineSel   term=bold cterm=bold gui=bold
hi TabLineFill  term=reverse cterm=reverse gui=reverse
hi CursorColumn term=reverse ctermbg=Grey guibg=Grey90
hi CursorLine   term=underline cterm=underline guibg=Grey90
hi ColorColumn  term=reverse ctermbg=DarkRed guibg=LightRed
hi Cursor       guifg=bg guibg=fg
hi lCursor      guifg=bg guibg=fg
hi MatchParen   term=reverse ctermbg=DarkCyan guibg=Cyan
hi Comment      term=bold ctermfg=DarkBlue guifg=#6699CC
hi Constant     term=underline ctermfg=DarkRed guifg=#DC322F
hi Special      term=bold ctermfg=DarkMagenta guifg=#C864C8
hi Identifier   term=underline cterm=NONE ctermfg=DarkCyan guifg=DarkCyan
hi Statement    term=bold ctermfg=Yellow gui=NONE guifg=#CCCC64
hi PreProc      term=underline ctermfg=DarkMagenta guifg=#C864C8
hi Type         term=underline ctermfg=DarkGreen gui=NONE guifg=#00C84B
hi Underlined   term=underline cterm=underline ctermfg=DarkMagenta gui=underline guifg=SlateBlue
hi Ignore       cterm=bold ctermfg=Grey guifg=bg
hi Error        term=reverse cterm=bold ctermfg=Grey ctermbg=DarkRed guifg=White guibg=Red
hi Todo         term=standout ctermfg=Black ctermbg=Yellow guifg=#6699CC guibg=#CCCC64

" Highlight when lines get longer than 120 characters
function! Highlight_long_lines()
    if len(&filetype)
        hi OverLength ctermbg=234 guibg=#1c1c1c
        match OverLength /\%121v.*/
    endif
endfunction
autocmd BufEnter * call Highlight_long_lines()

function! Highlight_trailing_whitespace()
    if len(&filetype)
        hi TrailingWhitespace ctermbg=DarkGrey guibg=DarkGrey
        2match TrailingWhitespace /\s\+$/
    endif
endfunction
autocmd BufEnter * call Highlight_trailing_whitespace()

" Tag stuff
set tags=./.vimtags;
let g:easytags_async = 1
let g:easytags_always_enabled = 1
let g:easytags_events = ['BufWritePost', 'CursorHold', 'BufReadPost']
let g:easytags_dynamic_files = 1
let g:easytags_include_members = 1
let g:easytags_auto_highlight = 0
call xolox#easytags#filetypes#add_mapping('proto', 'Protobuf')

let g:NERDDefaultAlign = 'left'
" <C-_> is actually CTRL-/ in (most?) terminals for some strange reason
if has('win32')
    nnoremap <silent> <C-/> :call nerdcommenter#Comment("n", "Toggle")<CR>
    vnoremap <silent> <C-/> :call nerdcommenter#Comment("v", "Toggle")<CR>
else
    nnoremap <silent> <C-_> :call nerdcommenter#Comment("n", "Toggle")<CR>
    vnoremap <silent> <C-_> :call nerdcommenter#Comment("v", "Toggle")<CR>
endif

if &encoding != 'utf-8'
    let &encoding = 'utf-8'
endif

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1

let g:formatdef_jq = '"jq"'
let g:formatters_json = ['jq']

let g:vimspector_enable_mappings = 'HUMAN'
" Launch the debugger
nmap <F1> <Plug>VimspectorContinue
" Close the debugger
nmap <Leader><F1> <Plug>VimspectorReset
" Query the value of the variable under the cursor
nmap <Leader>q <Plug>VimspectorBalloonEval
" Query the value of the selected expression
xmap <Leader>q <Plug>VimspectorBalloonEval
" Up and down the call stack
nmap <Leader><F11> <Plug>VimspectorUpFrame
nmap <Leader><F12> <Plug>VimspectorDownFrame

nnoremap <silent> <leader>f <Plug>(coc-fix-current)
nmap <silent> <leader>r <Plug>(coc-refactor)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
inoremap <silent><expr> <C-@> coc#refresh()

set completeopt-=preview

" Alias :Bdelte to :Bclose, since it's what I'm used to
command! -bang -complete=buffer -nargs=? Bclose Bdelete<bang> <args>

" Remap movement keys
" * hjkl are left, down, up, and right; as normal
" * HJKL are first non-whitespace char of line, page down, page up, and last
"   non-whiteapace char of line
" * <C-J>, <C-K>, and <C-M> are bottom of screen, top of screen, and middle of screen
"   <C-H> and <C-L> are previous word and next word
noremap <C-K> H
noremap <C-J> L
noremap <C-M> M
noremap <C-H> b
noremap <C-L> e
noremap H ^
noremap L $
noremap J <C-F>
noremap K <C-B>

" Map alt-h and alt-l to resize vertical splits
" and alt-j and alt-k to resize horizontal splits
if has('mac')
    " macOS treats Alt strangely, so map the actual keys that get generated
    " by alt+whatever
    nnoremap <silent> ˙ :vertical resize -2<cr>
    nnoremap <silent> ¬ :vertical resize +2<cr>
    nnoremap <silent> ∆ :resize +2<cr>
    nnoremap <silent> ˚ :resize -2<cr>
else
    nnoremap <silent> <A-h> :vertical resize -2<cr>
    nnoremap <silent> <A-l> :vertical resize +2<cr>
    nnoremap <silent> <A-j> :resize +2<cr>
    nnoremap <silent> <A-k> :resize -2<cr>
endif

" Map <C-n> to toggle the NERDTree file browser
nnoremap <C-n> :NERDTreeToggle<cr>

augroup NerdTreeCustomization

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
"autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
"    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif

augroup END

let NERDTreeMouseMode=2

let g:NERDTreeGitStatusUseNerdFonts = 1
let g:NERDTreeGitStatusHighlightingCustom = {
            \    'Unmerged':  'ctermfg=Red guifg=Red',
            \    'Deleted':   'ctermfg=Red guifg=Red',
            \    'Modified':  'ctermfg=Yellow guifg=Yellow',
            \    'Renamed':   'ctermfg=Yellow guifg=Yellow',
            \    'Untracked': 'ctermfg=Yellow guifg=Yellow',
            \    'Dirty':     'ctermfg=Yellow guifg=Yellow',
            \    'Staged':    'ctermfg=Green guifg=Green',
            \    'Ignored':   'ctermfg=Blue guifg=Blue'
            \}

let g:NERDTreeLimitedSyntax = 1

tnoremap <silent> <esc> <C-\><C-n>

nnoremap <silent> gs :SidewaysRight<cr>
nnoremap <silent> ga :SidewaysLeft<cr>

let dirparts = xolox#misc#path#split(expand('%:p:h'))
let dirname = dirparts[0]
let filename = xolox#misc#path#join([dirname, '.vimrc_local'])
if filereadable(filename)
    source filename
endif
for part in dirparts[1:-1]
    let dirname = xolox#misc#path#join([dirname, part])
    let filename = xolox#misc#path#join([dirname, '.vimrc_local'])
    if filereadable(filename)
        exec 'source '.filename
    endif
endfor
