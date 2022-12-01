-- :fennel:1669600990
do
  if (0 == vim.fn.isdirectory("/home/shui/.local/share/nvim/site/pack/packer/start/packer.nvim")) then
    print("packer.nvim: installing in data dir...")
    local function _1_(...)
      _G["packer_bootstrap"] = true
      return nil
    end
    do local _ = (vim.fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", "/home/shui/.local/share/nvim/site/pack/packer/start/packer.nvim"}) and _1_(...)) end
    vim.cmd("redraw")
    vim.cmd("packadd packer.nvim")
    print("packer.nvim: installed")
  else
  end
  do end (require("packer")).init({})
end
local function _3_(use)
  _G.assert((nil ~= use), "Missing argument use on plugins.fnl:3")
  use("wbthomason/packer.nvim")
  do
    use({"onsails/lspkind-nvim"})
    local function _4_()
      local ts = require("nvim-treesitter.configs")
      return ts.setup({ensure_installed = "all", highlight = {enable = true}})
    end
    use({config = _4_, "nvim-treesitter/nvim-treesitter"})
    use({"nvim-treesitter/nvim-treesitter-context"})
    use({"editorconfig/editorconfig-vim"})
    use({"neovim/nvim-lspconfig"})
    use({"scrooloose/nerdcommenter"})
    use({"kana/vim-arpeggio"})
    local function _5_()
      return vim.api.nvim_set_keymap("n", "<c-P>", "<cmd>lua require('fzf-lua').files({ cwd = require'find-root'.find_root(0)})<CR>", {noremap = true, silent = true})
    end
    use({config = _5_, "ibhagwan/fzf-lua"})
    use({"powerman/vim-plugin-AnsiEsc"})
    use({"hrsh7th/cmp-nvim-lsp"})
    use({"hrsh7th/cmp-path"})
    use({"hrsh7th/cmp-buffer"})
    use({"hrsh7th/cmp-calc"})
    use({"hrsh7th/cmp-cmdline"})
    use({"ray-x/cmp-treesitter"})
    use({"L3MON4D3/LuaSnip"})
    use({"saadparwaiz1/cmp_luasnip"})
    local function _6_()
      local crates = require("crates")
      local cmp = require("cmp")
      crates.setup()
      local config = cmp.get_config()
      table.insert(config.sources, {name = "crates"})
      return cmp.setup.buffer(config)
    end
    use({config = _6_, event = {"BufRead Cargo.toml"}, requires = {"nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp"}, "Saecki/crates.nvim"})
    local function _7_()
      return require("plugins.cmp")
    end
    use({config = _7_, "hrsh7th/nvim-cmp"})
    local function _8_()
      return (require("which-key")).setup({window = {position = "top", winblend = 1}})
    end
    use({config = _8_, "folke/which-key.nvim"})
    local function _9_()
      return (require("gitsigns")).setup()
    end
    use({config = _9_, requires = {"nvim-lua/plenary.nvim"}, "lewis6991/gitsigns.nvim"})
    use({"github/copilot.vim"})
    local function _10_()
      return (require("indent_blankline")).setup({show_current_context = true, show_current_context_start = true})
    end
    use({config = _10_, "lukas-reineke/indent-blankline.nvim"})
    use({"kyazdani42/nvim-web-devicons"})
    local function _11_()
      return (require("bufferline")).setup()
    end
    use({config = _11_, ensure_dependencies = true, requires = {"kyazdani42/nvim-web-devicons"}, "romgrk/barbar.nvim"})
    use({"h-hg/fcitx.nvim"})
    use({"Vonr/align.nvim"})
    local function _12_()
      return (require("leap")).add_default_mappings()
    end
    use({config = _12_, "ggandor/leap.nvim"})
    local function _13_()
      return require("plugins.noice")
    end
    use({config = _13_, ensure_dependencies = true, requires = {"MunifTanjim/nui.nvim", "rcarriga/nvim-notify"}, "folke/noice.nvim"})
    use({"stevearc/dressing.nvim"})
    use({"rcarriga/nvim-notify"})
    local function _14_()
      return (require("trouble")).setup()
    end
    use({config = _14_, ensure_dependencies = true, requires = {"kyazdani42/nvim-web-devicons"}, "folke/trouble.nvim"})
    use({"simrat39/rust-tools.nvim"})
    use({branch = "v2.x", ensure_dependencies = true, mod = "neo-tree", requires = {"kyazdani42/nvim-web-devicons", "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim"}, "nvim-neo-tree/neo-tree.nvim"})
    local function _15_()
      return (require("illuminate")).configure()
    end
    use({config = _15_, "RRethy/vim-illuminate"})
    use({"lambdalisue/suda.vim"})
    local function _16_()
      local surround = require("nvim-surround")
      return surround.setup({keymaps = {insert = "<C-g>f", normal = "yf", visual = "F", delete = "df", change = "cf"}})
    end
    use({config = _16_, "kylechui/nvim-surround"})
    local function _17_()
      return (require("mason")).setup()
    end
    use({config = _17_, "williamboman/mason.nvim"})
    local function _18_()
      return (require("mason-lspconfig")).setup()
    end
    use({config = _18_, ensure_installed = {"sumneko_lua"}, "williamboman/mason-lspconfig.nvim"})
    use({run = "cargo build --release", "eraserhd/parinfer-rust"})
    use({requires = {"kyazdani42/nvim-web-devicons"}, "nvim-lualine/lualine.nvim"})
    use({"RRethy/vim-tranquille"})
    use({"norcalli/nvim.lua"})
    local function _19_()
      return (require("tangerine")).setup({})
    end
    use({config = _19_, "udayvir-singh/tangerine.nvim"})
    use({"udayvir-singh/hibiscus.nvim"})
  end
  if (true == _G.packer_bootstrap) then
    return (require("packer")).sync()
  else
    return nil
  end
end
return (require("packer")).startup(_3_)