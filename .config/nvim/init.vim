"{{{ Utility functions
function! UPDATE_TAGS() "{{{
	let _f_=expand("%:p")
	let _cmd_='ctags -a -f ./tags --fields=+lKiSz --c-kinds=cdefgmnpstuvx --c++-kinds=cdefgmnpstuvx --extra=+q  ' . '"' . _f_ . '"'
	let _resp=system(_cmd_)
	unlet _cmd_
	unlet _f_
	unlet _resp
endfunction "}}}

function! s:is_whitespace() "{{{
	let col = col('.') - 1
	return ! col || getline('.')[col - 1] =~? '\s'
endfunction "}}}

function! s:dein_clear_unused() "{{{
	return map(dein#check_clean(), "delete(v:val, 'rf')")
endfunction "}}}

command DeinClear call s:dein_clear_unused()
"}}}

"{{{ Dein.vim plugins
set runtimepath^=~/.config/nvim/dein/repos/github.com/Shougo/dein.vim/

call dein#begin(expand('~/.config/nvim/dein/'))

call dein#add('Shougo/dein.vim')
call dein#add('Shougo/deoplete.nvim', {'merged': 0})
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')
call dein#add('othree/html5.vim')
call dein#add('tpope/vim-surround')
call dein#add('chrisbra/SudoEdit.vim')
call dein#add('pangloss/vim-javascript')
call dein#add('scrooloose/nerdcommenter')
call dein#add('scrooloose/nerdtree')
call dein#add('mattn/emmet-vim')
call dein#add('plasticboy/vim-markdown')
call dein#add('jiangmiao/auto-pairs')
"call dein#add('Raimondi/delimitMate')
call dein#add('Matt-Deacalion/vim-systemd-syntax')
call dein#add('neomake/neomake')
"call dein#add('idanarye/vim-dutyl')
call dein#add('leafgarland/typescript-vim')
call dein#add('nhooyr/neoman.vim')
call dein#add('junegunn/fzf', {'merged':0})
call dein#add('junegunn/fzf.vim')
call dein#add('kien/ctrlp.vim')
call dein#add('vim-scripts/Lucius')
call dein#add('vim-airline/vim-airline')
call dein#add('vim-airline/vim-airline-themes', {'depends' : ['vim-airline']})
call dein#add('bling/vim-bufferline')
call dein#add('ternjs/tern_for_vim', { 'build': 'npm install' })
call dein#add('carlitux/deoplete-ternjs', {'depends': ['deoplete.nvim', 'tern_for_vim']})
"call dein#add('tweekmonster/deoplete-clang2', {'depends' : ['deoplete.nvim'], 'merged': 1})
call dein#add('majutsushi/tagbar')
"call dein#add('rhysd/vim-clang-format')
"call dein#add('lyuts/vim-rtags')
"call dein#add('critiqjo/lldb.nvim')
call dein#add('kana/vim-arpeggio')
"call dein#add('google/vim-maktaba')
"call dein#add('google/vim-codefmt', { 'depends' : ['vim-maktaba'], 'merged': 0})
"call dein#add('google/vim-glaive')
call dein#add('editorconfig/editorconfig-vim')
call dein#add('arakashic/chromatica.nvim', {'merged': 0})
"call dein#add('mhartington/nvim-typescript', {'depends' : ['deoplete.nvim']})
call dein#add('autozimu/LanguageClient-neovim', {'rev': 'next', 'build': 'make release'})
call dein#add('yshui/tooltip.nvim')
call dein#add('udalov/kotlin-vim')

call dein#end()
"call maktaba#plugin#Detect()

"call glaive#Install()

if dein#check_install()
  call dein#install()
endif
"}}}

"{{{ Timers

let g:idle_timer = -1
func! s:idle_callback(timer)
	Neomake
endfunc

func! s:input_callback()
	if g:idle_timer >= 0
		call timer_stop(g:idle_timer)
	endif
	let g:idle_timer = timer_start(5000, function('s:idle_callback'), {'repeat': 1})
endfunc

autocmd InsertCharPre * call s:input_callback()

"Experimenting with long press key map
let g:press_timer = -1
let g:repeat_count = -1

func! s:long_press_j_cancel()
	echomsg "canceled"
	let g:repeat_count = -1
	let g:press_timer = -1
endfunc

func! s:long_press_j()
	if g:press_timer >= 0
		"Called before timer expires, assuming repeated key
		"enter wait mode
		echomsg "repeating"
		let ret = ""
		call timer_stop(g:press_timer)
		if g:repeat_count < 0
			let g:repeat_count = 10
			let ret = "\<backspace>"
		elseif g:repeat_count > 0
			let g:repeat_count -= 1
		endif

		if g:repeat_count == 0
			echomsg "You did it!"
		endif
		let g:press_timer = timer_start(200, 's:long_press_j_cancel', {'repeat': 1})
		return ret
	elseif g:press_timer == -1
		"Just started
		echomsg "starting"
		let g:press_timer = timer_start(200, 's:long_press_j_cancel', {'repeat': 1})
		return "2"
	endif
endfunc
"inoremap <expr> 2 <SID>long_press_j()

"}}}


source $VIMRUNTIME/menu.vim

"{{{ Basic vim configurations

"Set tmux window name and title
autocmd BufEnter * call system("tmux rename-window \"nvim: ".expand("%:t")."\"")
set title

"Return to the last edit position
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif
set mouse=a
syntax enable

set hlsearch
set backup
set backupdir=$HOME/.vimf/backup,.
set directory=$HOME/.vimf/swap,.
set fileencodings=ucs-bom,utf-8,gbk,gb2312,cp936,gb18030,big5,euc-jp,euc-kr,latin1
set undodir=~/.vimf/undodir
set undofile
set undolevels=1000
set undoreload=10000
set updatetime=4000
set tags=tags;/
set backspace=2
set grepprg=grep\ -nH\ $*
set wildmenu
set cpo-=<
set wcm=<C-Z>
set laststatus=2
set clipboard=unnamedplus
map <F4> :emenu <C-Z>
au BufRead,BufNewFile * let b:start_time=localtime()
set completeopt=menu,menuone,preview
set shada=!,'150,<100,/50,:50,r/tmp,s256
"au FileType c,cpp,vim let w:mcc=matchadd('ColorColumn', '\%81v', 100)

set smartindent
set ofu=syntaxcomplete#Complete
"List Char
"set list!
set listchars=tab:>-,trail:-,extends:>
set viewoptions-=options

"Color Scheme
let g:gardener_light_comments=1
let g:gardener_blank=1
let g:lucius_use_bold=1
set background=dark
if v:progname =~? "gvim"
	colors lucius
else
	colorscheme gardener
endif

let g:nvim_config_dir = $HOME."/.config/nvim"
if $XDG_CONFIG_DIR != ""
	let g:nvim_config_dir = $XDG_CONFIG_DIR."/nvim"
endif


filetype plugin on
filetype plugin indent on

"autocmd! BufWritePost * Neomake
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent! loadview
"}}}

"{{{ Plugin configurations
let g:tooltip_border_width=10
let g:tooltip_background="white"
let g:tooltip_foreground="black"
"{{{ Clang paths

let g:__clang_path = '/usr/lib/libclang.so'
let g:chromatica#libclang_path = g:__clang_path

"}}}
"{{{ Chromatic
let g:chromatica#highlight_feature_level = 0
let g:chromatica#responsive_mode = 1
let g:chromatica#enable_at_startup = 1
"}}}
"{{{ Arpeggio
function! s:chords_setup()
	Arpeggio inoremap ji <ESC>
	Arpeggio inoremap jk <C-\><C-O>:close<CR>
	Arpeggio inoremap wq <C-\><C-O>:wq<CR>
	Arpeggio inoremap fq <C-\><C-O>:q!<CR>
	Arpeggio inoremap wr <C-\><C-O>:w<CR>

	Arpeggio noremap jk :close<CR>
	Arpeggio noremap wq :wq<CR>
	Arpeggio noremap fq :q!<CR>
	Arpeggio noremap wr :w<CR>
endfunction

autocmd VimEnter * call s:chords_setup()
"}}}
"{{{ LanguageClient
let g:LanguageClient_serverCommands = {
    \ 'c': ['cquery', '--language-server', '--log-file', '/tmp/a'],
    \ 'cpp': ['cquery', '--language-server', '--log-file', '/tmp/a'],
    \ 'rust': ['rls'],
    \ 'typescript': [$HOME.'/node_modules/.bin/typescript-language-server', '--stdio'],
\ }
let g:LanguageClient_autoStart = 1
let g:LanguageClient_settingsPath = g:nvim_config_dir.'/settings.json'
let g:LanguageClient_loadSettings = 1
"}}}

"{{{ AutoPairs/delimitMate
let delimitMate_expand_space = 1
let delimitMate_expand_cr = 1
let delimitMate_jump_expansion = 1
let g:AutoPairsMapCR = 0
"}}}

"{{{ deoplete.vim
let g:deoplete#enable_at_startup = 1

let g:deoplete#enable_smart_case = 1

let g:clang2_placeholder_prev = '<s-c-k>'
let g:clang2_placeholder_next = '<c-k>'

"let g:deoplete#sources#d#dcd_client_binary = "dcd-client"
"let g:deoplete#sources#d#dcd_server_binary = "dcd-server"

let g:deoplete#omni#input_patterns = get(g:,'deoplete#omni#input_patterns',{})
let g:deoplete#omni#input_patterns.d = [
	\'\.\w*',
	\'\w*\('
\]

let g:deoplete#omni#functions = get(g:,'deoplete#omni#functions',{})
"}}}

"{{{ dutyl
let g:dutyl_neverAddClosingParen=1
let g:dutyl_stdImportPaths=['/usr/include/dlang/dmd']
"}}}

"{{{ airline
let g:airline_powerline_fonts = 1
let g:airline_theme = "wombat"
"}}}

"{{{ clang-format
let g:clang_format#detect_style_file = 1
"}}}

"{{{ neomake
let g:neomake_error_sign = {
    \ 'text': 'E>',
    \ 'texthl': 'YcmErrorSection',
    \ }
let g:neomake_warning_sign = {
    \ 'text': 'W>',
    \ 'texthl': 'YcmWarningSection',
    \ }
"}}}

"{{{ SudoEdit
let g:sudoAuth = "sudo"
let g:sudo_no_gui = 1
"}}}

"{{{ syntastic
let g:syntastic_always_populate_loc_list=1
let g:syntastic_python_python_exec = '/usr/bin/python'
"let g:syntastic_python_checkers=['python', 'py3kwarn']
"}}}

"{{{ LaTeX
let g:Tex_DefaultTargetFormat='pdf'
let g:Tex_CompileRule_pdf='xelatex --shell-escape --interaction=nonstopmode $*'
let g:tex_flavor='latex'
"}}}
"{{{ Neomake
let g:neomake_c_gccw_maker = {
   \ 'exe': $HOME."/.config/nvim/cdb_wrapper",
   \ 'args': ['gcc', '-fsyntax-only', '-Wall', '-Wextra'],
   \ 'errorformat':
      \ '%-G%f:%s:,' .
      \ '%f:%l:%c: %trror: %m,' .
      \ '%f:%l:%c: %tarning: %m,' .
      \ '%f:%l:%c: %m,'.
      \ '%f:%l: %trror: %m,'.
      \ '%f:%l: %tarning: %m,'.
      \ '%f:%l: %m',
\ }
let g:neomake_c_clangw_maker = {
   \ 'exe': $HOME."/.config/nvim/cdb_wrapper",
   \ 'args': ['clang', '-fsyntax-only', '-Wall', '-Wextra'],
   \ 'errorformat':
      \ '%-G%f:%s:,' .
      \ '%f:%l:%c: %trror: %m,' .
      \ '%f:%l:%c: %tarning: %m,' .
      \ '%f:%l:%c: %m,'.
      \ '%f:%l: %trror: %m,'.
      \ '%f:%l: %tarning: %m,'.
      \ '%f:%l: %m',
\ }
let g:neomake_c_enabled_makers = []
let g:neomake_cpp_enabled_makers = []
let g:neomake_cpp_clang_args = ["-std=c++14", "-Wextra", "-Wall", "-fsanitize=undefined","-g"]
"}}}
"{{{ emmet
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
"}}}
"}}}

"{{{ FileType configurations

function! s:chords_c()
	Arpeggio inoremap rf <C-\><C-O>:call rtags#FindRefs()<CR><ESC>
	Arpeggio inoremap rj <C-\><C-O>:call rtags#JumpTo(g:V_SPLIT)<CR>
	Arpeggio noremap rf :call rtags#FindRefs()<CR>
	Arpeggio noremap rj :call rtags#JumpTo(g:V_SPLIT)<CR>
endfunction

autocmd FileType c,cpp call s:chords_c()
autocmd FileType python set shiftwidth=4
autocmd FileType python set nosmartindent
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1  " Rails support
autocmd FileType java setlocal noexpandtab " do not expand tabs to spaces for Java
autocmd FileType rust setlocal tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab
autocmd FileType xml,html,phtml,php,xhtml,js let b:delimitMate_matchpairs = "(:),[:],{:}"
autocmd FileType markdown set spell spelllang=en_us
autocmd FileType lua set expandtab shiftwidth=4 tabstop=8 softtabstop=4 textwidth=80
autocmd BufNewFile,BufRead *.mi set filetype=mite
au BufNewFile,BufRead meson.build set filetype=meson
au BufNewFile,BufRead meson_options.txt set filetype=meson
"}}}

"{{{ Misc mappings
map <silent> <C-N> :let @/=""<CR>
map <F2> :!/usr/bin/ctags -R --fields=+lKiSz --c-kinds=+cdefgmnpstuvx --c++-kinds=+cdefgmnpstuvx --extra=+q .<CR>
imap <C-n> <esc>nli

inoremap <silent> <F8> <C-\><C-O>:TagbarToggle<CR>
nnoremap <silent> <F8> :TagbarToggle<CR>
noremap  <buffer> <silent> <Up>   gk
noremap  <buffer> <silent> <Down> gj
noremap  <buffer> <silent> <Home> g<Home>
noremap  <buffer> <silent> <End>  g<End>
nnoremap <space> :
function s:lc_hover()
	let r = LanguageClient_textDocument_hoverSync()
	if type(r) != 7
		call ShowTooltip(screenrow(), screencol(), r["contents"][0]["value"])
	endif
endfunc
"autocmd CursorHold *.c call s:lc_hover()
autocmd CursorMoved *.c call HideTooltip()
noremap <silent><c-t> :call <SID>lc_hover()<CR>

cnoreabbrev Man Snman
"}}}

inoremap <F6> <c-g>u<esc>:call zencoding#expandAbbr(0)<cr>a


"{{{ deoplete.vim related mappings
imap <expr><CR>  pumvisible() ?
\ (neosnippet#expandable() ? "\<Plug>(neosnippet_expand)" : deoplete#mappings#close_popup()."\<Plug>(neosnippet_jump)") :
\ "\<CR>\<Plug>AutoPairsReturn"

inoremap <expr><C-h>
\ deoplete#mappings#smart_close_popup()."\<C-h>"

inoremap <expr><BS>
\ deoplete#mappings#smart_close_popup()."\<C-h>"

imap <expr><TAB> pumvisible() ? "\<C-n>" :
\ neosnippet#jumpable() ? "\<Plug>(neosnippet_jump)" :
\ <SID>is_whitespace() ? "\<TAB>" : deoplete#mappings#manual_complete()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <F7> <C-\><C-O>:Neomake<CR>
nnoremap <F7> :Neomake<CR>

smap <expr><TAB> neosnippet#jumpable() ?
\ "\<Plug>(neosnippet_jump)"
\: "\<TAB>"
"}}}
"
"{{{commands
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
"}}}

"List Char
set list!
set listchars=tab:>-,trail:-,extends:>

nnoremap ; :

cnoreabbrev Man Snman
" vim: foldmethod=marker
