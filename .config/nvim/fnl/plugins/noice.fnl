(let [notify (require :notify)]
  (notify.setup {:background_colour "#1e222a"}))

(let [noice (require :noice)]
  (noice.setup 
    {:views    {:cmdline_popup {:position {:row "70%"}}
                :hover {:border {:style "rounded"}}}
     :messages {:view "mini"}
     :lsp {:override {:vim.lsp.util.convert_input_to_markdown_lines true
                      :vim.lsp.util.stylize_markdown true
                      :cmp.entry.get_documentation true}}
     :presets {:lsp_doc_border true}}))
