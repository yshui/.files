(import-macros
  {:augroup! aug!
   : color!
   : g!
   :set! o!
   :set+ o+
   :rem! o-}
  :hibiscus.vim)
(local nvim (require :nvim))
(require :settings)
(require :lsp)
(require :plugins)

(color! monokai)

(g! neovide_transparency 0.5)
(g! loaded_netrw 1)
(g! loaded_netrwPlugin 1)
(g! suda_smart_edit 1)
(o! hlsearch)
(o! backup)
(o! secure)
(o! wildmenu)
(o! title)
(o! nowrap)
(o! laststatus 3)
(o+ shortmess :c)
(o- backupdir :.)
(o! background :dark)
(o! mouse :a)
(o! backspace "indent,eol,start")
(o! timeoutlen 300)
(o! updatetime 500)
(o! noshowmode)
(o! clipboard :unnamedplus)
(o! guifont "Iosevka Term:h8")
(o! titlestring "%f - NVIM")
(o! completeopt "menuone,noinsert,noselect")
(o! listchars "tab:>-,trail:-,extends:>")
(o! shada "!,\'150,<100,/50,:50,r/tmp,s256")

(if (= (os.getenv :COLORTERM) "truecolor")
  (o! termguicolors))

(fn au/ [event pattern f]
 (nvim.create_autocmd event {:pattern pattern :callback f}))
(fn au [event pattern cmd]
 (nvim.create_autocmd event {:pattern pattern :command cmd}))

(au :FileType :fennel :IndentBlanklineDisable)
(au :FileType :fennel "set et")
(au :FileType [:c :cpp] "set comments^=:/// nosmartindent preserveindent")
(au :FileType :python "set sw=4 nosmartindent")
(au :FileType :markdown "set spell spelllang=en_us")
(au [:BufNewFile :BufRead] ["*.frag" "*.vert"] "set filetype=glsl")
(au [:BufNewFile :BufRead] [:meson.build :meson_options.txt] "set filetype=toml")

(fn tmux-apply-title []
 (->
   "tmux rename-window \"nvim: "
   (.. (vim.fn.expand "%:t") "\"")
   (io.popen)
   (: :close)))
(fn tmux-reset-title []
  (->
    (io.popen "tmux set-window-option automatic-rename on")
    (: :close)))

(au/ [:VimEnter :BufEnter :VimResume] "*" tmux-apply-title)
(au/ [:VimLeave :VimSuspend] "*" tmux-reset-title)
(au/ [:BufWritePost] :plugins.fnl #(let [packer (require :packer) tangerine (require :tangerine.api)]
                                    (tangerine.compile.buffer)
                                    ; reload the plugins.lua module
                                    (set package.loaded.plugins nil)
                                    (require :plugins)
                                    (packer.compile)))
