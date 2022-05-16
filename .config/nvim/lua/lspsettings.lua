local lsp_status = require('lsp-status')
lsp_status.register_progress()

local lspconfig = require'lspconfig'
local capabilities = require'cmp_nvim_lsp'.update_capabilities(lsp_status.capabilities)

lspconfig.rust_analyzer.setup{
    on_attach = lsp_status.on_attach,
    capabilities = capabilities
}

lspconfig.clangd.setup{
    on_attach = lsp_status.on_attach,
    capabilities = capabilities
}

lspconfig.serve_d.setup{
    on_attach = lsp_status.on_attach,
    capabilities = capabilities
}

lspconfig.csharp_ls.setup{
    on_attach = lsp_status.on_attach,
    capabilities = capabilities
}

