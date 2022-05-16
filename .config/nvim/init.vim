"{{{ Utility functions

function! s:is_whitespace() "{{{
	let col = col('.') - 1
	return ! col || getline('.')[col - 1] =~? '\s'
endfunction "}}}

function! s:tmux_apply_title() "{{{
	call system("tmux rename-window \"nvim: ".expand("%:t")."\"")
endfunc "}}}

function! s:tmux_reset_title() "{{{
	call system("tmux set-window-option automatic-rename on")
endfunc "}}}
"}}}

lua require('settings')

"{{{ Basic vim configurations

"Set tmux window name and title
autocmd VimEnter * call s:tmux_apply_title()
autocmd BufEnter * call s:tmux_apply_title()
autocmd VimResume * call s:tmux_apply_title()
autocmd VimLeave * call s:tmux_reset_title()
autocmd VimSuspend * call s:tmux_reset_title()

"Return to the last edit position
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") && expand("%:t") != "COMMIT_EDITMSG" |
  \   exe "normal! g`\"" |
  \ endif

set wcm=<C-Z>
"au BufRead,BufNewFile * let b:start_time=localtime()
"au FileType c,cpp,vim let w:mcc=matchadd('ColorColumn', '\%81v', 100)

"List Char
"set list!
set viewoptions-=options

colorscheme monokai

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

"{{{ emmet
"let g:user_emmet_install_global = 0
"autocmd FileType html,css EmmetInstall
"}}}
"}}}

"{{{ FileType configurations

autocmd Filetype c,cpp set comments^=:///
autocmd FileType python set shiftwidth=4
autocmd FileType python set nosmartindent
autocmd FileType cpp set nosmartindent preserveindent
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1  " Rails support
autocmd FileType java setlocal noexpandtab " do not expand tabs to spaces for Java
autocmd FileType rust setlocal tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab
autocmd FileType xml,html,phtml,php,xhtml,js let b:delimitMate_matchpairs = "(:),[:],{:}"
autocmd FileType markdown set spell spelllang=en_us
autocmd FileType lua set expandtab shiftwidth=4 tabstop=8 softtabstop=4 textwidth=80
autocmd BufNewFile,BufRead *.frag,*.vert set filetype=glsl
au BufNewFile,BufRead meson.build set filetype=meson
au BufNewFile,BufRead meson_options.txt set filetype=meson

"}}}

"{{{ Misc mappings
map <silent> <C-N> :let @/=""<CR>

"}}}


"{{{ completion related mappings
"imap <expr><CR>  "\<CR>\<Plug>AutoPairsReturn"

"imap <expr><TAB> pumvisible() ? "\<C-n>" : <SID>is_whitespace() ? "\<TAB>" : compe#complete()

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<S-Tab>"

"}}}

"{{{commands
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)
"}}}

"{{{ Terminal
tnoremap <Esc><Esc> <C-\><C-n>
tnoremap <Esc>vs <C-\><C-n>:vsplit \| term<CR>
autocmd TermOpen * setlocal timeoutlen=1000
"}}}

" vim: foldmethod=marker
