(require-macros :hibiscus.packer)
(packer-setup)
(packer
  (use! :onsails/lspkind-nvim)
  (use! :nvim-treesitter/nvim-treesitter
        :config (lambda []
                  (let [ts (require :nvim-treesitter.configs)]
                    (ts.setup {:ensure_installed "all"
                               :highlight {:enable true}}))))

  (use! :nvim-treesitter/nvim-treesitter-context)
  (use! :editorconfig/editorconfig-vim)
  (use! :neovim/nvim-lspconfig)
  (use! :scrooloose/nerdcommenter)
  (use! :kana/vim-arpeggio)
  (use! :ibhagwan/fzf-lua
        :config (lambda []
                  (vim.api.nvim_set_keymap
                    "n" "<c-P>" "<cmd>lua require('fzf-lua').files({ cwd = require'find-root'.find_root(0)})<CR>"
                    {:noremap true :silent true})))
  (use! :powerman/vim-plugin-AnsiEsc)
  (use! :hrsh7th/cmp-nvim-lsp)
  (use! :hrsh7th/cmp-path)
  (use! :hrsh7th/cmp-buffer)
  (use! :hrsh7th/cmp-calc)
  (use! :hrsh7th/cmp-cmdline)
  (use! :ray-x/cmp-treesitter)
  (use! :L3MON4D3/LuaSnip)
  (use! :saadparwaiz1/cmp_luasnip)
  (use! :Saecki/crates.nvim
        :event ["BufRead Cargo.toml"]
        :requires [:nvim-lua/plenary.nvim :hrsh7th/nvim-cmp]
        :config #(let [crates (require :crates) cmp (require :cmp)]
                   (crates.setup)
                   (let [config (cmp.get_config)]
                    (table.insert config.sources {:name "crates"})
                    (cmp.setup.buffer config))))
  (use! :hrsh7th/nvim-cmp :module "plugins.cmp")
  (use! :folke/which-key.nvim
        :config (lambda []
                  ((. (require :which-key) :setup)
                   { :window {:position "top" :winblend 1}})))
  (use! :lewis6991/gitsigns.nvim
        :requires [ :nvim-lua/plenary.nvim]
        :config (lambda [] ((. (require :gitsigns) :setup))))
  (use! :github/copilot.vim)
  (use! :lukas-reineke/indent-blankline.nvim
        :config (lambda []
                  ((. (require :indent_blankline) :setup)
                   { :show_current_context true
                     :show_current_context_start true})))
  (use! :kyazdani42/nvim-web-devicons)
  (use! :romgrk/barbar.nvim
        :requires [:kyazdani42/nvim-web-devicons]
        :ensure_dependencies true
        :config #((. (require :bufferline) :setup)))
  (use! :h-hg/fcitx.nvim)
  (use! :Vonr/align.nvim)
  (use! :ggandor/leap.nvim
        :config #((. (require :leap) :add_default_mappings)))
  (use! :folke/noice.nvim
        :module "plugins.noice"
        :requires [:MunifTanjim/nui.nvim :rcarriga/nvim-notify]
        :ensure_dependencies true)
  (use! :stevearc/dressing.nvim)
  (use! :rcarriga/nvim-notify)
  (use! :folke/trouble.nvim
        :requires [:kyazdani42/nvim-web-devicons]
        :ensure_dependencies true
        :config #((. (require :trouble) :setup)))
  (use! :simrat39/rust-tools.nvim)
  (use! :nvim-neo-tree/neo-tree.nvim
        :branch "v2.x"
        :requires [:kyazdani42/nvim-web-devicons
                    :nvim-lua/plenary.nvim
                    :MunifTanjim/nui.nvim]
        :ensure_dependencies true
        :mod "neo-tree")
  (use! :RRethy/vim-illuminate
        :config #((. (require :illuminate) :configure)))
  (use! :lambdalisue/suda.vim)
  (use! :kylechui/nvim-surround
        :config #(let [surround (require :nvim-surround)]
                  (surround.setup {:keymaps {:insert "<C-g>f"
                                             :normal "yf"
                                             :visual "F"
                                             :delete "df"
                                             :change "cf"}})))
  (use! :williamboman/mason.nvim :config #((. (require :mason) :setup)))
  (use! :williamboman/mason-lspconfig.nvim
        :config #((. (require :mason-lspconfig) :setup) {:ensure_installed [:sumneko_lua]}))
  (use! :eraserhd/parinfer-rust :run "cargo build --release")
  (use! :nvim-lualine/lualine.nvim :requires [:kyazdani42/nvim-web-devicons])
  (use! :RRethy/vim-tranquille)
  (use! :norcalli/nvim.lua)
  (use! :udayvir-singh/tangerine.nvim :config #((. (require :tangerine) :setup) {}))
  (use! :udayvir-singh/hibiscus.nvim)
  (use! :kosayoda/nvim-lightbulb :config #((. (require :nvim-lightbulb) :setup) {:autocmd {:enabled true}}))
  (use! :weilbith/nvim-code-action-menu :cmd "CodeActionMenu"))
