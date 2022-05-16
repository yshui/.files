-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]
return require('packer').startup(function()

use 'neovim/nvim-lspconfig'
use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = function()
    require 'nvim-treesitter.configs'.setup {ensure_installed = 'maintained', highlight = {enable = true}}
end}
use { 'wbthomason/packer.nvim', branch = "master" }
use 'bhurlow/vim-parinfer'
use 'roxma/nvim-yarp'
use 'nvim-lua/lsp-status.nvim'
-- use { 'neoclide/coc.nvim', run = 'yarn install' }
use 'LnL7/vim-nix'
use 'othree/html5.vim'
use 'tpope/vim-surround'
use 'chrisbra/SudoEdit.vim'
use 'pangloss/vim-javascript'
use 'scrooloose/nerdcommenter'
use 'scrooloose/nerdtree'
use 'mattn/emmet-vim'
use 'plasticboy/vim-markdown'
use 'rust-lang/rust.vim'
use 'Matt-Deacalion/vim-systemd-syntax'
use 'leafgarland/typescript-vim'
use 'junegunn/fzf'
use 'reasonml-editor/vim-reason-plus'
use 'vim-scripts/Lucius'
-- use 'vim-airline/vim-airline'
-- use { 'vim-airline/vim-airline-themes', requires = { 'vim-airline' }}
use { 'ternjs/tern_for_vim', run = 'npm install' }
use 'kana/vim-arpeggio'
use 'editorconfig/editorconfig-vim'
use 'udalov/kotlin-vim'
use 'junegunn/fzf.vim'
use 'powerman/vim-plugin-AnsiEsc'
-- use 'jackguo380/vim-lsp-cxx-highlight'
use { 'tami5/lspsaga.nvim', requires = { 'nvim-lspconfig' }, config = function()
   require'lspsaga'.init_lsp_saga()
end}
use 'onsails/lspkind-nvim'

--{{{ cmp sources
use 'hrsh7th/cmp-nvim-lsp'
use 'hrsh7th/cmp-path'
use 'hrsh7th/cmp-buffer'
use 'hrsh7th/cmp-calc'
use 'hrsh7th/cmp-cmdline'
use 'L3MON4D3/LuaSnip'
use 'saadparwaiz1/cmp_luasnip'
use {
    'Saecki/crates.nvim',
    event = { "BufRead Cargo.toml" },
    requires = { { 'nvim-lua/plenary.nvim' } },
    config = function()
        require('crates').setup()
        require('cmp').setup.buffer { sources = { { name = 'crates' } } }
    end,
}
use 'ray-x/cmp-treesitter'
--}}}

use { 'hrsh7th/nvim-cmp', requires = { 'nvim-lspconfig', 'onsails/lspkind-nvim' }, config = function()
    local cmp = require'cmp'
    cmp.setup {
        snippet = {
            expand = function(args)
                require'luasnip'.lsp_expand(args.body)
            end
        },
        sources = {
            { name = 'nvim_lsp' },
            { name = 'path' },
            { name = 'buffer' },
            { name = 'calc' },
            { name = 'treesitter' },
            { name = 'cmdline' },
            { name = 'luasnip' }
        },
        formatting = {
            format = require'lspkind'.cmp_format({with_text = false, maxwidth = 50})
        },
        mapping = {
            ['<C-e>'] = cmp.mapping(function(fallback)
                local luasnip = require'luasnip'
                if luasnip.jumpable(1) then
                    luasnip.jump(1)
                else
                    cmp.mapping.close()
                end
            end, {'i', 's'}),
            ['<CR>'] = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            }),
            ['<C-f>'] = cmp.mapping({
                i = cmp.mapping.abort(),
                c = cmp.mapping.close(),
            }),
            ['<Tab>'] = cmp.mapping({
                c = function(fallback)
                    if #cmp.core:get_sources() > 0 and not cmp.get_config().experimental.native_menu then
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            cmp.complete()
                        end
                    else
                        fallback()
                    end
                end,
                i = function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif require'utils'.is_whitespace() then
                        fallback()
                    else
                        cmp.complete()
                    end
                end,
            }),
            ['<S-Tab>'] = cmp.mapping({
                c = function(fallback)
                    if #cmp.core:get_sources() > 0 and not cmp.get_config().experimental.native_menu then
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            cmp.complete()
                        end
                    else
                        fallback()
                    end
                end,
                i = function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        cmp.complete()
                    end
                end,
            }),
        }
    }
    cmp.setup.cmdline('/', {
        sources = {
            { name = 'buffer' }
        }
    })
    cmp.setup.cmdline(':', {
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        })
    })
end}
use 'ziglang/zig.vim'
use 'wsdjeg/dein-ui.vim'
use { 'liuchengxu/vim-which-key', opt = true, cmd = { 'WhichKey' }}
use 'liuchengxu/vista.vim'use {
  'nvim-lualine/lualine.nvim',
  requires = {'kyazdani42/nvim-web-devicons', opt = true}
}
use {
  'lewis6991/gitsigns.nvim',
  requires = {
    'nvim-lua/plenary.nvim'
  },
  config = function()
    require('gitsigns').setup()
  end
}
use {
  'kdheepak/tabline.nvim',
  config = function()
    require'tabline'.setup { }
    vim.cmd[[
      set guioptions-=e " Use showtabline in gui vim
      set sessionoptions+=tabpages,globals " store tabpages and globals in session
    ]]
  end,
  requires = { { 'hoob3rt/lualine.nvim', opt=true }, {'kyazdani42/nvim-web-devicons', opt = true} }
}
end)
