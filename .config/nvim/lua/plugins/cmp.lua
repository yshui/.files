local cmp = require 'cmp'
local luasnip = require 'luasnip'
local has_words_before = require 'utils'.has_words_before
local cmp_kind = require 'lspkind'.cmp_kind
local tab_is = function(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  elseif has_words_before() then
    cmp.complete()
  else
    fallback()
  end
end
local stab_is = function(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end
cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'treesitter' },
    { name = 'path' },
    { name = 'buffer' },
    { name = 'luasnip' },
    { name = 'calc' },
  },
  formatting = {
    format = require 'lspkind'.cmp_format {
      mode = 'symbol',
      maxwidth = 50,
      before = function(entry, item)
        item.menu = ({
          buffer = "﬘",
          nvim_lsp = "",
          luasnip = "🐍",
          treesitter = "",
          nvim_lua = "",
          spell = "暈",
          -- emoji = "ﲃ",
          copilot = "🤖",
          -- cmp_tabnine = "🤖",
          look = "﬜",
        })[entry.source.name]
        if item.menu == nil then
          item.menu = entry.source.name
        end
        return item
      end,
    },
  },
  mapping = {
    ["<C-j>"] = cmp.mapping(function(fallback)
      cmp.mapping.abort()
      local copilot_keys = vim.fn["copilot#Accept"]()
      if copilot_keys ~= "" then
        vim.api.nvim_feedkeys(copilot_keys, "i", true)
      else
        fallback()
      end
    end),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ['<C-_>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<C-/>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<Tab>'] = cmp.mapping({
      i = tab_is,
      s = tab_is,
      c = function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end,
    }),
    ['<S-Tab>'] = cmp.mapping({
      c = function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end,
      i = stab_is,
      s = stab_is,
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
