(local lspconfig (require :lspconfig))
(local capabilities ((. (require :cmp_nvim_lsp) :default_capabilities)))
(local rust-tools (require :rust-tools))
(local WK (require :which-key))

(rust-tools.setup
 {:server
  {:settings
   {:rust-analyzer
    {:checkOnSave { :command "clippy"}}}}

  :on_attach #((WK.register
                {:g {:name "code action" :r [rust-tools.hover_actions.hover_actions "hover actions"]}}
                {:buffer $2 :prefix :<leader>})
               (rust-tools.inlay_hints.set))})

(lspconfig.csharp_ls.setup {:capabilities capabilities})
(lspconfig.yamlls.setup {:capabilities capabilities})

(let [clangd_capabilities (vim.deepcopy capabilities)]
  (set clangd_capabilities.offsetEncoding :utf-8)
  (lspconfig.clangd.setup {:capabilities clangd_capabilities}))

(lspconfig.sumneko_lua.setup
 {:capabilities capabilities
  :settings
  {:Lua
   {:runtime {:version "LuaJIT"}
    :diagnostics {:globals [:vim :di] :unusedLocalExclude "_*"}
    :workspace {:library (vim.api.nvim_get_runtime_file "" true)}
    :telemetry {:enable false}}}})
