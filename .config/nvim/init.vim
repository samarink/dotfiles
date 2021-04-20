" Plugins {{{
call plug#begin('~/.vim/plugged')

Plug 'honza/vim-snippets'
Plug 'sheerun/vim-polyglot'                       " syntax highlighting library
Plug 'neoclide/coc.nvim', {'branch': 'release'}

Plug 'bling/vim-bufferline'
Plug 'itchyny/lightline.vim'                      " status line
Plug 'tpope/vim-vinegar'                          " file explorer

Plug '907th/vim-auto-save'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'                           " tap plugins into . command
Plug 'kana/vim-textobj-user'                      " custom text objects
Plug 'kana/vim-textobj-entire'                    " entire file as text object
Plug 'tpope/vim-unimpaired'                       " collection of mappings
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'                         " git wrapper
Plug 'airblade/vim-gitgutter'                     " git diff in the gutter
Plug 'mattn/emmet-vim'

" color schemes
Plug 'arcticicestudio/nord-vim'

call plug#end()
" }}}

" Plugin Settings {{{
let g:user_emmet_leader_key=',' " press leader twice to trigger emmet

" enable autosave plugin
let g:auto_save = 1
let g:auto_save_silent = 1

" fzf {{{
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Keyword', 'border': 'sharp' } }

let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" global exports
let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'
let $FZF_DEFAULT_COMMAND="rg --files --hidden -g !.git/"

" helper functions
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0)

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --hidden --ignore-case --no-heading --color=always '.shellescape(<q-args>), 1,
  \   <bang>0 ? fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'up:60%')
  \           : fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}, 'right:50%:hidden', '?'),
  \   <bang>0)
"}}}

" Airline {{{
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'nord',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'gitbranch', 'filename' ] ],
      \ },
      \ 'component': {
      \   'readonly': '%{&readonly?"":""}',
      \   'bufferline': '%{bufferline#refresh_status()}%{g:bufferline_status_info.before . g:bufferline_status_info.current . g:bufferline_status_info.after}',
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ 'separator':    { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' },
\ }
" }}}

" Conquer of Completion {{{
nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

let g:coc_snippet_next = '<Tab>'
let g:coc_snippet_prev = '<S-Tab>'

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"

autocmd CursorHold * silent call CocActionAsync('highlight')

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

command! -nargs=0 Format :call CocAction('format')

let g:coc_global_extensions = [
  \'coc-yank',
  \'coc-css',
  \'coc-html',
  \'coc-eslint',
  \'coc-emmet',
  \'coc-json',
  \'coc-snippets',
  \'coc-tsserver',
  \'coc-prettier',
  \'coc-pyright',
  \]
" }}}
" }}}

" General {{{
set ts=2 sts=2 sw=2 expandtab       " tab behaviour
set mouse=a                         " enable mouse support
set path+=**                        " append working directory to path
set foldmethod=marker               " enable folding
set scrolloff=5                     " keep n lines below cursor position
set linebreak                       " wrap lines to viewport width
set cursorline                      " hightlight current line
set noswapfile                      " allow switching buffers without writing
set undofile                        " save undo history to a file
set splitright splitbelow           " fix split behaviour
set clipboard=unnamedplus           " copy paste from system clipboard

" search behaviour
set ignorecase
set smartcase

" performance tweaks
set lazyredraw
set redrawtime=10000
set synmaxcol=180

" required by coc
set hidden
set nobackup
set nowritebackup
set cmdheight=2
set updatetime=300
set shortmess+=c
set signcolumn=yes

" automatic toggling between line number modes
set number relativenumber
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" disable auto commenting on new lines
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e
" }}}

" Key Mappings {{{
" remap leader
let mapleader = ","
nnoremap \ ,

" more convinient mappings
nmap <Tab> :bnext<CR>
nmap <S-Tab> :bprevious<CR>

" edit shortcuts
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
map <leader>ew :e %%
map <leader>es :sp %%
map <leader>ev :vsp %%
map <leader>et :tabe %%

" git-fugitive
map <leader>g :G<space>
map <leader>gw :Gwrite<CR>
map <leader>gc :G commit -v<CR>
map <leader>gs :Gstatus<CR>
map <leader>gd :Gdiff<CR>
map <leader>gr :Gread<CR>
map <leader>gx :Gremove<CR>
map <leader>gm :Gmove %%<space>
map <leader>ga :G commit --amend -v<CR>
map <leader>gp :G push origin<CR>

" fzf
nmap <leader>f :Files<CR>
nmap <C-f> :Rg<CR>
nmap <leader>b :Buffers<CR>

" format
noremap <leader>c :Format<CR>
noremap <leader>af :CocCommand eslint.executeAutofix<CR>

" center the screen
inoremap zz <Esc>zzi

" coc mappings
nmap <silent> gd <Plug>(coc-definition)
nmap <leader>qf  <Plug>(coc-fix-current)
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" move between windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" move visual line, not literal
nmap j gj
nmap k gk

" move to first/last non whitespace char
noremap H ^
noremap L $

" windows resizing shortcuts
nnoremap <Up> :resize +2<CR>
nnoremap <Down> :resize -2<CR>
nnoremap <Left> :vertical resize +2<CR>
nnoremap <Right> :vertical resize -2<CR>

" bubble lines up
nmap <C-Up> [e
nmap <C-Down> ]e

" play a macro at q
nnoremap <Space> @q

" save as sudo
cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" for unhighlighing the serach (vim tip 80)
nnoremap <silent> <M-l> :<C-u>nohlsearch<CR><C-l>

" copy whole line except newline char
nnoremap Y 0vg_y

" keep the cursor in the same place after yank
vmap y ygv<Esc>

" keep selection after indent
vnoremap > ><CR>gv
vnoremap < <<CR>gv
"" }}}

" Colorscheme {{{
set termguicolors

" colorscheme tweaks
let g:nord_uniform_status_lines = 1
let g:nord_uniform_diff_background = 1
let g:nord_italic = 1
let g:nord_italic_comments = 1
let g:nord_underline = 1
let g:nord_cursor_line_number_background = 1
let g:nord_bold_vertical_split_line = 1
colorscheme nord

" git-gutter: transparent gutter
highlight DiffAdd    guifg=#a8ce93 guibg=NONE ctermfg=10 ctermbg=NONE
highlight DiffDelete guifg=#df8c8c guibg=NONE ctermfg=12 ctermbg=NONE
highlight DiffChange guifg=#f2c38f guibg=NONE ctermfg=14 ctermbg=NONE

" make background transparent
highlight Normal        guibg=NONE ctermbg=NONE
highlight LineNr        guibg=NONE ctermbg=NONE
highlight SignColumn    guibg=NONE ctermbg=NONE
" }}}
