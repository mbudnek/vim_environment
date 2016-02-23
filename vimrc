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

" basic options
set hlsearch
filetype plugin on
filetype indent on
set wildmenu
set wildmode=list:longest
set directory=~/.vim/tmp

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

" Colors
colorscheme default
hi Comment	term=bold		ctermfg=DarkCyan		guifg=#80a0ff

" Pyflakes
let g:PyFlakeCheckers = 'pep8,frosted'
let g:PyFlakeCWindow = 0
let g:PyFlakeDisabledMessages = 'E309'

" Tag stuff
set tags=./.vimtags;
let g:easytags_async = 1
let g:easytags_events = ['BufWritePost', 'CursorHold', 'BufReadPost']
let g:easytags_dynamic_files = 1
let g:easytags_include_members = 1
let g:easytags_auto_highlight = 0

" Alias :Bdelte to :Bclose, since it's what I'm used to
command! -bang -complete=buffer -nargs=? Bclose Bdelete<bang> <args>

" Remap movement keys
noremap <C-K> H
noremap <C-J> L
noremap <C-M> M
noremap H ^
noremap L $
noremap J <C-F>
noremap K <C-B>
