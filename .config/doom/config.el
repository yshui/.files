(setq warning-minimum-level :error)
(setq doom-font (font-spec :family "DeTerminus"))
(setq confirm-kill-emacs nil)
(def-package! evil-terminal-cursor-changer
              :commands (evil-terminal-cursor-changer-activate etcc-on)
              :config
              (setq evil-motion-state-cursor 'box)  ; █
              (setq evil-visual-state-cursor 'box)  ; █
              (setq evil-normal-state-cursor 'box)  ; █
              (setq evil-insert-state-cursor 'bar)  ; ⎸
              (setq evil-emacs-state-cursor  'hbar)) ; _')
(xterm-mouse-mode 1)
(defun on-after-init ()
  (unless (display-graphic-p (selected-frame))
    (set-face-background 'default "unspecified-bg" (selected-frame))))
(add-hook 'window-setup-hook 'on-after-init)
(unless (display-graphic-p)
        (evil-terminal-cursor-changer-activate)) ; or (etcc-on)

(def-package! company-lsp
             :commands company-lsp
             :config (push 'company-lsp company-backends)
                     (setq company-lsp-enable-snippet t))
(def-package! ccls)
(def-package! lsp-mode
             :commands lsp
             :hook ((c-mode c++-mode) . lsp)
             :config (setq lsp-enable-snippet t))
(set-company-backend! '(c-mode c++-mode cuda-mode objc-mode) 'company-lsp)
