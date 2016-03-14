" Load pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()

" Tabs
" Use a 5 space tab character and 4 space soft tabs to easily tell when tabs
" and spaces are mixed
set tabstop=5
set softtabstop=4
set shiftwidth=4
set expandtab

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


" clipboard stuff
set clipboard=unnamed,unnamedplus,autoselect
" attempt to write the contents of vim's yank buffer to the clipboard on quit
function! Write_clipboard()
    if len(getreg('+')) > 0
        call system('xclip -i -selection clipboard', getreg('+'))
    endif
endfun
autocmd VimLeave * call Write_clipboard()
nnoremap <silent> dd dd:call setreg('*', getreg('+'))<CR>
nnoremap <silent> yy yy:call setreg('*', getreg('+'))<CR>

function! PEP8_check()
    if &filetype == "python"
        execute("PyFlake")
    endif
endfun
autocmd BufReadPost * call PEP8_check()

" Colors
hi clear Normal
hi clear
hi SpecialKey   term=bold ctermfg=4 guifg=Blue
hi NonText      term=bold cterm=bold ctermfg=4 gui=bold guifg=Blue
hi Directory    term=bold ctermfg=4 guifg=Blue
hi ErrorMsg     term=standout cterm=bold ctermfg=7 ctermbg=1 guifg=White guibg=Red
hi IncSearch    term=reverse cterm=reverse gui=reverse
hi Search       term=reverse ctermfg=0 ctermbg=3 guibg=Yellow
hi MoreMsg      term=bold ctermfg=2 gui=bold guifg=SeaGreen
hi ModeMsg      term=bold cterm=bold gui=bold
hi LineNr       term=underline ctermfg=3 guifg=Brown
hi CursorLineNr term=bold ctermfg=3 gui=bold guifg=Brown
hi Question     term=standout ctermfg=2 gui=bold guifg=SeaGreen
hi StatusLine   term=bold,reverse cterm=bold,reverse gui=bold,reverse
hi StatusLineNC term=reverse cterm=reverse gui=reverse
hi VertSplit    term=reverse cterm=reverse gui=reverse
hi Title        term=bold ctermfg=5 gui=bold guifg=Magenta
hi Visual       term=reverse cterm=reverse guibg=LightGrey
hi VisualNOS    term=bold,underline cterm=bold,underline gui=bold,underline
hi WarningMsg   term=standout ctermfg=1 guifg=Red
hi WildMenu     term=standout ctermfg=0 ctermbg=3 guifg=Black guibg=Yellow
hi Folded       term=standout ctermfg=4 ctermbg=7 guifg=DarkBlue guibg=LightGrey
hi FoldColumn   term=standout ctermfg=4 ctermbg=7 guifg=DarkBlue guibg=Grey
hi DiffAdd      term=bold ctermbg=4 guibg=LightBlue
hi DiffChange   term=bold ctermbg=5 guibg=LightMagenta
hi DiffDelete   term=bold cterm=bold ctermfg=4 ctermbg=6 gui=bold guifg=Blue guibg=LightCyan
hi DiffText     term=reverse cterm=bold ctermbg=1 gui=bold guibg=Red
hi SignColumn   term=standout ctermfg=4 ctermbg=7 guifg=DarkBlue guibg=Grey
hi Conceal      ctermfg=7 ctermbg=0 guifg=LightGrey guibg=DarkGrey
hi SpellBad     term=reverse ctermbg=1 gui=undercurl guisp=Red
hi SpellCap     term=reverse ctermbg=4 gui=undercurl guisp=Blue
hi SpellRare    term=reverse ctermbg=5 gui=undercurl guisp=Magenta
hi SpellLocal   term=underline ctermbg=6 gui=undercurl guisp=DarkCyan
hi Pmenu        ctermfg=0 ctermbg=5 guibg=LightMagenta
hi PmenuSel     ctermfg=0 ctermbg=7 guibg=Grey
hi PmenuSbar    ctermbg=7 guibg=Grey
hi PmenuThumb   ctermbg=0 guibg=Black
hi TabLine      term=underline cterm=underline ctermfg=0 ctermbg=7 gui=underline guibg=LightGrey
hi TabLineSel   term=bold cterm=bold gui=bold
hi TabLineFill  term=reverse cterm=reverse gui=reverse
hi CursorColumn term=reverse ctermbg=7 guibg=Grey90
hi CursorLine   term=underline cterm=underline guibg=Grey90
hi ColorColumn  term=reverse ctermbg=1 guibg=LightRed
hi Cursor       guifg=bg guibg=fg
hi lCursor      guifg=bg guibg=fg
hi MatchParen   term=reverse ctermbg=6 guibg=Cyan
hi Comment      term=bold ctermfg=4 guifg=Blue
hi Constant     term=underline ctermfg=1 guifg=Magenta
hi Special      term=bold ctermfg=5 guifg=SlateBlue
hi Identifier   term=underline ctermfg=6 guifg=DarkCyan
hi Statement    term=bold ctermfg=3 gui=bold guifg=Brown
hi PreProc      term=underline ctermfg=5 guifg=Purple
hi Type         term=underline ctermfg=2 gui=bold guifg=SeaGreen
hi Underlined   term=underline cterm=underline ctermfg=5 gui=underline guifg=SlateBlue
hi Ignore       cterm=bold ctermfg=7 guifg=bg
hi Error        term=reverse cterm=bold ctermfg=7 ctermbg=1 guifg=White guibg=Red
hi Todo         term=standout ctermfg=0 ctermbg=3 guifg=Blue guibg=Yellow

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

" Alias :Bdelte to :Bclose, since it's what I'm used to
command! -bang -complete=buffer -nargs=? Bclose Bdelete<bang> <args>

" Remap movement keys
" * hjkl are left, down, up, and right; as normal
" * HJKL are first non-whitespace char of line, page down, page up, and last
"   non-whiteapace char of line
" * <C-H>, <C-J>, <C-K>, and <C-L> are Home, bottom of screen, top of screen,
"   and End
" * <C-M> is middle of screen
noremap <C-K> H
noremap <C-J> L
noremap <C-M> M
noremap <C-H> <HOME>
noremap <C-L> <END>
noremap H ^
noremap L $
noremap J <C-F>
noremap K <C-B>
