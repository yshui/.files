require 'pl'

local cmd = vim.cmd -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn -- to call Vim functions e.g. fn.bufnr()
local g = vim.g -- a table to access global variables
local v = vim.v

local scopes = { o = vim.o, b = vim.bo, w = vim.wo }

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
  local options = { noremap = true }
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

local HOME = os.getenv('HOME')

-- {{{ Basic vim configurations
optb 'undofile'
optb 'smartindent'
optw 'list'

opt('fileencodings', 'ucs-bom,utf-8,gbk,gb2312,cp936,gb18030,big5,euc-jp,euc-kr,latin1')
optb('modeline', false)

-- }}}

-- }}}

-- {{{ General
g['mapleader'] = ' '
g['maplocalleader'] = ','

-- }}}

-- {{{ Neovide
g['neovide_cursor_animation_length'] = 0.02
g['neovide_cursor_trail_length'] = 0.2
-- }}}

-- {{{ Plugin configurationsArpeggio inoremap wq <cmd>wq<CR>
-- {{{ Clang paths
local clang_path = '/usr/lib/libclang.so'
g['chromatica#libclang_path'] = clang_path
-- }}}

-- {{{ Chromatic
g['chromatica#highlight_feature_level'] = 0
g['chromatica#responsive_mode'] = 1
g['chromatica#enable_at_startup'] = 1
-- }}}

-- {{{ EditorConfig
g['EditorConfig_preserve_formatoptions'] = 1
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

g['copilot_no_tab_map'] = true
g['copilot_assume_mapped'] = true
g['copilot_tab_fallback'] = ""
-- }}}

-- {{{ Key maps
local WK = require 'which-key'

map('i', '<F8>', '<C-\\><C-O>:Vista coc<CR>', { silent = true })
map('n', '<F8>', ':Vista coc<CR>', { silent = true })
map('', '<Up>', 'gk', { silent = true, buffer = true })
map('', '<Down>', 'gj', { silent = true, buffer = true })
map('', '<Home>', 'g<Home>', { silent = true, buffer = true })
map('', '<End>', 'g<End>', { silent = true, buffer = true })
map('i', '<C-p>', '<C-\\><C-O>:Files<CR>')
map('n', '<C-p>', ':Files<CR>')

map('n', ';', ':')

local trouble = require'trouble'
WK.register({
  K = { vim.lsp.buf.hover, "hover" },
  F = {
    function()
      require 'neo-tree.command'.execute {
        action = "show",
        source = "filesystem",
        position = "left",
        reveal = true,
        dir = require 'find-root'.find_root(vim.api.nvim_get_current_buf())
      }
    end, "file explorer"
  },
  g = {
    name = "actions",
    f = { vim.lsp.buf.format, "format" },
    a = { vim.lsp.buf.code_action, "code action" },
    d = { vim.lsp.buf.definition, "definition" },
    ["]"] = { function() trouble.next({skip_groups = false}) end, "next diagnostic" },
    ["["] = { function() trouble.previous({skip_groups = false}) end, "previous diagnostic" },
  }
})

-- }}}

-- {{{ Arpeggio
function arpeggio_setup()
  arpeggio({ 'i', '' }, 'wq', '<cmd>wq<CR>')
  arpeggio({ 'i', '' }, 'wr', '<cmd>w<CR>')
  arpeggio({ 'i', '' }, 'fq', '<cmd>q!<CR>')
  arpeggio({ 'i', '' }, 'qt', '<cmd>q<CR>')
  arpeggio({ 'i', '' }, 'jk', '<cmd>close<CR>')
  arpeggio({ 'i' }, 'ji', '<ESC>')
  -- arpeggio({'i', ''}, 'eo0', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  -- arpeggio({'i', ''}, 'ei0', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  -- arpeggio({'i', ''}, 'ac0', '<cmd>lua codeaction:code_action()<CR>')
  -- arpeggio({'i', ''}, 'har', '<cmd>lua lsphover:render_hover_doc()<CR>')
  arpeggio({ 'i', '' }, 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>')
  -- arpeggio({'i', ''}, 'pd', '<cmd>Lspsaga preview_definition()<CR>')
  arpeggio({ 'i', '' }, 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  -- arpeggio({'i', ''}, 'ref', '<cmd>Lspsaga lsp_finder()<CR>')
  -- arpeggio({'i', ''}, 'rn', '<cmd>lua lsprename:lsp_rename()<CR>')
  arpeggio({ 'i', '' }, 'fm', '<cmd>lua vim.lsp.buf.format { async = true }<CR>')
  arpeggio({ 'x' }, 'fm', '<cmd>lua vim.lsp.buf.range_formatting()<CR>')
end

-- vim.api.nvim_command('autocmd VimEnter * lua arpeggio_setup()')
-- }}}

-- {{{ lsp
-- " Show diagnostic popup on cursor hover
local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
  group = diag_float_grp,
})
-- }}}
vim.api.nvim_command("autocmd User LspProgressUpdate redrawstatus!")
local function lsp_progress()
  local messages = vim.lsp.util.get_progress_messages()
  if vim.b['lsp_progress_message_count'] == nil then
    vim.b['lsp_progress_message_count'] = 0
  end
  if #messages == 0 then
    return ""
  end
  vim.b['lsp_progress_message_count'] = vim.b['lsp_progress_message_count'] + #messages
  local status = {}
  for _, msg in pairs(messages) do
    table.insert(status, (msg.percentage or 0) .. "%% " .. (msg.title or ""))
  end
  local spinners = {
    "⠋",
    "⠙",
    "⠹",
    "⠸",
    "⠼",
    "⠴",
    "⠦",
    "⠧",
    "⠇",
    "⠏",
  }
  local frame = vim.b['lsp_progress_message_count'] % #spinners
  return table.concat(status, " | ") .. " " .. spinners[frame + 1]
end

require 'lualine'.setup { sections = { lualine_c = { 'filename', lsp_progress } } }

--[[
vim.lsp.set_log_level 'trace'
if vim.fn.has 'nvim-0.5.1' == 1 then
    require('vim.lsp.log').set_format_func(vim.inspect)
end
--]]

local NS = { noremap = true, silent = true }

vim.keymap.set('x', 'aa', function() require 'align'.align_to_char(1, true) end, NS) -- Aligns to 1 character, looking left
vim.keymap.set('x', 'as', function() require 'align'.align_to_char(2, true, true) end, NS) -- Aligns to 2 characters, looking left and with previews
vim.keymap.set('x', 'aw', function() require 'align'.align_to_string(false, true, true) end, NS) -- Aligns to a string, looking left and with previews
vim.keymap.set('x', 'ar', function() require 'align'.align_to_string(true, true, true) end, NS) -- Aligns to a Lua pattern, looking left and with previews

-- Example gawip to align a paragraph to a string, looking left and with previews
vim.keymap.set(
  'n',
  'gaw',
  function()
    local a = require 'align'
    a.operator(
      a.align_to_string,
      { is_pattern = false, reverse = true, preview = true }
    )
  end,
  NS
)

-- Example gaaip to aling a paragraph to 1 character, looking left
vim.keymap.set(
  'n',
  'gaa',
  function()
    local a = require 'align'
    a.operator(
      a.align_to_char,
      { reverse = true }
    )
  end,
  NS
)

vim.api.nvim_create_user_command('UpdateEverything', function(_arg)
  local auid
  auid = vim.api.nvim_create_autocmd({ 'User' }, {
    pattern = 'PackerComplete',
    callback = function()
      local notify = require 'notify'
      vim.api.nvim_del_autocmd(auid)
      vim.cmd [[PackerCompile]]
      vim.cmd [[TSUpdate]]
      for _, pkg in ipairs(require 'mason-registry'.get_installed_packages()) do
        pkg:check_new_version(function(success, result_or_err)
          if success then
            notify('Updating ' ..
              pkg.name .. ' from ' .. result_or_err.current_version .. ' to ' .. result_or_err.latest_version, 'info')
            pkg:install({ version = result_or_err.latest_version })
          end
        end)
      end
      notify('Checked mason packages!', 'info')
    end,
  })
  vim.cmd [[ PackerSync ]]
end, { desc = "Update everything" })

-- vim: foldmethod=marker foldenable
