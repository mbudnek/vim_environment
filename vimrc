" Load pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
" Suppress easytags warning about ctags not being installed
" It's really annoying, and I don't really need easytags everywhere
" This has to be here before I call pathogen#infect so that it's
" visible when the easytags plugin loads.
let g:easytags_suppress_ctags_warning = 1
call pathogen#infect()

" Tabs
" Use a 5 space tab character and 4 space soft tabs to easily tell when tabs
" and spaces are mixed
set tabstop=5
set softtabstop=4
set shiftwidth=4
set expandtab

set backspace=indent,eol,start

" cindent params
" these more-or-less match the google C++ style guide
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
        if &filetype ==? 'c' || &filetype ==? 'cpp'
            let s:notelse = '\%(\<else\>\s\+\)\@<!'
            let s:notif = '\%(\s\+\<if\>\)\@!'
            let b:match_words = b:match_words . ',' . s:notelse . '\<if\>:\<else\s\+if\>:\<else\>' . s:notif
        endif
    endfun
    autocmd BufNewFile,BufRead * call Add_if_else_if_if_to_match_words()
catch
endtry

" clipboard stuff
set clipboard=unnamed,unnamedplus
" Don't enable autoselect on windows since it only has one clipboard
" and thus autoselect prevents pasting over selected text since
" the selected text will automatically replace the current clipboard contents
if !has('win32') && !has('win32unix')
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
autocmd VimLeave * call Write_clipboard()
nnoremap <silent> dd dd:call Sync_clipboard_to_selection()<CR>
nnoremap <silent> yy yy:call Sync_clipboard_to_selection()<CR>

function! PEP8_check()
    if &filetype == "python"
        execute("PyFlake")
    endif
endfun
autocmd BufReadPost * call PEP8_check()

" Colors
set bg&
hi clear
hi clear Normal
hi clear Visual
hi SpecialKey   term=bold ctermfg=DarkBlue guifg=Blue
hi NonText      term=bold cterm=bold ctermfg=DarkBlue gui=bold guifg=Blue
hi Directory    term=bold ctermfg=DarkBlue guifg=Blue
hi ErrorMsg     term=standout cterm=bold ctermfg=Grey ctermbg=DarkRed guifg=White guibg=Red
hi IncSearch    term=reverse cterm=reverse gui=reverse
hi Search       term=reverse ctermfg=Black ctermbg=Yellow guibg=Yellow
hi MoreMsg      term=bold ctermfg=DarkGreen gui=bold guifg=SeaGreen
hi ModeMsg      term=bold cterm=bold gui=bold
hi LineNr       term=underline ctermfg=Yellow guifg=Brown
hi CursorLineNr term=bold ctermfg=Yellow gui=bold guifg=Brown
hi Question     term=standout ctermfg=DarkGreen gui=bold guifg=SeaGreen
hi StatusLine   term=bold,reverse cterm=bold,reverse gui=bold,reverse
hi StatusLineNC term=reverse cterm=reverse gui=reverse
hi VertSplit    term=reverse cterm=reverse gui=reverse
hi Title        term=bold ctermfg=DarkMagenta gui=bold guifg=Magenta
hi Visual       term=reverse cterm=reverse guibg=LightGrey
hi VisualNOS    term=bold,underline cterm=bold,underline gui=bold,underline
hi WarningMsg   term=standout ctermfg=DarkRed guifg=Red
hi WildMenu     term=standout ctermfg=Black ctermbg=Yellow guifg=Black guibg=Yellow
hi Folded       term=standout ctermfg=DarkBlue ctermbg=Grey guifg=DarkBlue guibg=LightGrey
hi FoldColumn   term=standout ctermfg=DarkBlue ctermbg=Grey guifg=DarkBlue guibg=Grey
hi DiffAdd      term=bold ctermbg=Black
hi DiffChange   term=bold ctermbg=Black
hi DiffDelete   term=bold ctermbg=Black
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
hi Comment      term=bold ctermfg=DarkBlue guifg=Blue
hi Constant     term=underline ctermfg=DarkRed guifg=Magenta
hi Special      term=bold ctermfg=DarkMagenta guifg=SlateBlue
hi Identifier   term=underline ctermfg=DarkCyan guifg=DarkCyan
hi Statement    term=bold ctermfg=Yellow gui=bold guifg=Brown
hi PreProc      term=underline ctermfg=DarkMagenta guifg=Purple
hi Type         term=underline ctermfg=DarkGreen gui=bold guifg=SeaGreen
hi Underlined   term=underline cterm=underline ctermfg=DarkMagenta gui=underline guifg=SlateBlue
hi Ignore       cterm=bold ctermfg=Grey guifg=bg
hi Error        term=reverse cterm=bold ctermfg=Grey ctermbg=DarkRed guifg=White guibg=Red
hi Todo         term=standout ctermfg=Black ctermbg=Yellow guifg=Blue guibg=Yellow

" Highlight when lines get longer than 120 characters
function! Highlight_long_lines()
    if len(&filetype)
        hi OverLength ctermbg=Black guibg=#592929
        match OverLength /\%121v.*/
    endif
endfunction
autocmd BufEnter * call Highlight_long_lines()

function! Highlight_trailing_whitespace()
    if len(&filetype)
        hi TrailingWhitespace ctermbg=Black guibg=Black
        2match TrailingWhitespace /\s\+$/
    endif
endfunction
autocmd BufEnter * call Highlight_trailing_whitespace()

" Pyflakes
let g:PyFlakeCheckers = 'pep8,frosted'
let g:PyFlakeCWindow = 0
let g:PyFlakeDisabledMessages = 'E309'
let g:PyFlakeMaxLineLength = 120

" Tag stuff
let discovered_filetypes = []
let command_line = xolox#easytags#ctags_command()
if !empty(command_line)
    let starttime = xolox#misc#timer#start()
    let command_line .= ' --list-languages'
    for line in xolox#misc#os#exec({'command': command_line})['stdout']
      if line =~ '^\w\S*$'
        call add(supported_filetypes)
      endif
    endfor
endif

set tags=./.vimtags;
let g:easytags_async = 1
let g:easytags_always_enabled = 1
let g:easytags_events = ['BufWritePost', 'CursorHold', 'BufReadPost']
let g:easytags_dynamic_files = 1
let g:easytags_include_members = 1
let g:easytags_auto_highlight = 0
if index(discovered_filetypes, 'Protobuf')
     call xolox#easytags#filetypes#add_mapping('proto', 'Protobuf')
endif

let g:NERDDefaultAlign = 'left'
nnoremap <silent> <C-P> :call NERDComment("n", "Toggle")<CR>
vnoremap <silent> <C-P> :call NERDComment("v", "Toggle")<CR>

if &encoding != 'utf-8'
    let &encoding = 'utf-8'
endif

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_skip_empty_sections = 1

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

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

noremap <silent> gb :SidewaysRight<cr>
noremap <silent> gB :SidewaysLeft<cr>
let @s='gb'
map gs @s
let @r='gB'
map ga @r

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
