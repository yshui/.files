local lsp_status = require('lsp-status')
lsp_status.register_progress()

local lspconfig = require'lspconfig'
local capabilities = require'cmp_nvim_lsp'.update_capabilities(lsp_status.capabilities)

lspconfig.rust_analyzer.setup{
    on_attach = lsp_status.on_attach,
    capabilities = capabilities
}

local clangd_capabilities = capabilities
clangd_capabilities.offsetEncoding = 'utf-8'
lspconfig.clangd.setup{
    on_attach = lsp_status.on_attach,
    capabilities = clangd_capabilities
}

lspconfig.serve_d.setup{
    on_attach = lsp_status.on_attach,
    capabilities = capabilities
}

lspconfig.csharp_ls.setup{
    on_attach = lsp_status.on_attach,
    capabilities = capabilities
}

