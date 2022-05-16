require'pl'
require'lspsettings'

-- {{{ lspsaga
local lspsaga = require 'lspsaga'
lspprovider = require'lspsaga.provider'
codeaction = require'lspsaga.codeaction'
lsphover = require'lspsaga.hover'
lsprename = require'lspsaga.rename'
lspdiag = require'lspsaga.diagnostic'

-- }}}

local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local v = vim.v

local scopes = {o = vim.o, b = vim.bo, w = vim.wo}

local function arpeggio(modes, key, sequence)
    for _, m in ipairs(modes) do
        vim.api.nvim_command(string.format("Arpeggio %snoremap %s %s", m, key, sequence))
    end
end

local function opt_(scope, key, value)
  if value == nil then
      value = true
  end
  scopes[scope][key] = value
  if scope ~= 'o' then scopes['o'][key] = value end
end

local function opt(key, value)
    return opt_('o', key, value)
end

local function optb(key, value)
    return opt_('b', key, value)
end

local function optw(key, value)
    return opt_('w', key, value)
end

local function map(mode, lhs, rhs, opts)
  local options = {noremap = true}
  local buffer = (opts and opts['buffer']) or false
  if opts then
      opts['buffer'] = nil
      options = vim.tbl_extend('force', options, opts)
  end
  if buffer then
    vim.api.nvim_buf_set_keymap(0, mode, lhs, rhs, options)
  else
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  end
end

local HOME=os.getenv('HOME')

-- {{{ Basic vim configurations

opt 'hlsearch'
opt 'backup'
opt 'secure'
opt 'wildmenu'
opt 'title'
optb 'undofile'
optb 'smartindent'
optw 'list'

opt('mouse', 'a')
opt('backspace', '2')
opt('timeoutlen', 300)
opt('updatetime', 500)
opt('showmode', false)
opt('tags', 'tags;/')
opt('clipboard', 'unnamedplus')
opt('guifont', 'Iosevka:h12')
opt('titlestring', '%f - NVIM')
opt('grepprg', 'grep -nH $*')
opt('completeopt', 'menu,menuone,noselect')
opt('listchars', 'tab:>-,trail:-,extends:>')
opt('backupdir', path.join(HOME, '.vimf', 'backup')..',.')
opt('directory', path.join(HOME, '.vimf', 'swap')..',.')
opt('undodir', path.join(HOME, '.vimf', 'undodir'))
opt('shada', '!,\'150,<100,/50,:50,r/tmp,s256')
opt('fileencodings', 'ucs-bom,utf-8,gbk,gb2312,cp936,gb18030,big5,euc-jp,euc-kr,latin1')
optb('modeline', false)

-- {{{ Color scheme
opt('background', 'dark')

if os.getenv('COLORTERM') == "truecolor" then
    opt 'termguicolors'
end

-- }}}

require'plugins'

-- }}}

-- {{{ General
g['mapleader'] = ' '
g['maplocalleader'] = ','

-- }}}

-- {{{ Plugin configurationsArpeggio inoremap wq <cmd>wq<CR>
-- {{{ Clang paths
local clang_path = '/usr/lib/libclang.so'
g['chromatica#libclang_path'] = clang_path
-- }}}

-- {{{ Chromatic
g['chromatica#highlight_feature_level']= 0
g['chromatica#responsive_mode'] = 1
g['chromatica#enable_at_startup'] = 1
-- }}}

-- {{{ EditorConfig
g['EditorConfig_preserve_formatoptions'] =1
-- }}}

-- {{{Parinfer
-- Disable Parinfer filetype commands by default
g['vim_parinfer_filetypes'] = {}
g['vim_parinfer_globs'] = { "*.el", "*.lisp", "*.scm" }
--- }}}

-- {{{ SudoEdit
g['sudo_askpass'] = '/usr/lib/seahorse/ssh-askpass'
g['sudoDebug'] = 1
-- }}}

-- {{{ syntastic
g['syntastic_always_populate_loc_list'] = 1
g['syntastic_python_python_exec'] = '/usr/bin/python'
--let g:syntastic_python_checkers=['python', 'py3kwarn']
-- }}}

-- {{{ LaTeX
g['Tex_DefaultTargetFormat'] = 'pdf'
g['Tex_CompileRule_pdf'] = 'xelatex --shell-escape --interaction=nonstopmode $*'
g['tex_flavor'] = 'latex'
-- }}}

-- {{{ AutoPairs
g['AutoPairsMapCR'] = 0
-- }}}

-- }}}

-- {{{ Key maps

map('n', '<leader>', ':<c-u>WhichKey \'<Space>\'<CR>', { silent = true })
map('n', '<localleader>', ':<c-u>WhichKey  \',\'<CR>', { silent = true })

map('i', '<F8>', '<C-\\><C-O>:Vista coc<CR>', { silent = true })
map('n', '<F8>', ':Vista coc<CR>', { silent = true })
map('', '<Up>', 'gk', { silent = true, buffer = true })
map('', '<Down>', 'gj', { silent = true, buffer = true })
map('', '<Home>', 'g<Home>', { silent = true, buffer = true })
map('', '<End>', 'g<End>', { silent = true, buffer = true })
map('i', '<C-p>', '<C-\\><C-O>:Files<CR>')
map('n', '<C-p>', ':Files<CR>')

map('n', ';', ':')

-- }}}

-- {{{ Arpeggio
function arpeggio_setup()
    arpeggio({'i', ''}, 'wq', '<cmd>wq<CR>')
    arpeggio({'i', ''}, 'wr', '<cmd>w<CR>')
    arpeggio({'i', ''}, 'fq', '<cmd>q!<CR>')
    arpeggio({'i', ''}, 'qt', '<cmd>q<CR>')
    arpeggio({'i', ''}, 'jk', '<cmd>close<CR>')
    arpeggio({'i'}, 'ji', '<ESC>')
    arpeggio({'i', ''}, 'eo0', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
    arpeggio({'i', ''}, 'ei0', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
    arpeggio({'i', ''}, 'ac0', '<cmd>lua codeaction.code_action()<CR>')
    arpeggio({'i', ''}, 'har', '<cmd>lua lsphover.render_hover_doc()<CR>')
    arpeggio({'i', ''}, 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
    arpeggio({'i', ''}, 'pd', '<cmd>lua lspprovider.preview_definition()<CR>')
    arpeggio({'i', ''}, 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
    arpeggio({'i', ''}, 'ref', '<cmd>lua lspprovider.lsp_finder()<CR>')
    arpeggio({'i', ''}, 'rn', '<cmd>lua lsprename.rename()<CR>')
    arpeggio({'i', ''}, 'fm', '<cmd>lua vim.lsp.buf.formatting()<CR>')
    arpeggio({'x'}, 'fm', '<cmd>lua vim.lsp.buf.range_formatting()<CR>')
end

vim.api.nvim_command('autocmd VimEnter * lua arpeggio_setup()')
-- }}}

-- {{{ lspsaga
vim.api.nvim_command('autocmd CursorHold * lua lspdiag.show_cursor_diagnostics()')
vim.api.nvim_command('autocmd CursorHoldI * lua lspdiag.show_cursor_diagnostics()')
-- }}}

local lsp_status = require'lsp-status'
local function lsp_progress()
    return lsp_status.status_progress()
end
require'lualine'.setup{sections = { lualine_c = {'filename', lsp_progress} } }

--[[
vim.lsp.set_log_level 'trace'
if vim.fn.has 'nvim-0.5.1' == 1 then
    require('vim.lsp.log').set_format_func(vim.inspect)
end
--]]

-- vim: foldmethod=marker foldenable
