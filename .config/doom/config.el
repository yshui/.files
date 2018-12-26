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
(evil-terminal-cursor-changer-activate)
(defun process-frame (frame)
  (unless (display-graphic-p frame)
    (set-face-background 'default "unspecified-bg" frame)))

(defun on-reload-theme (&rest _)
  (dolist (frame (frame-list))
    (process-frame frame)))

; Change background color on theme reload, append the hook because
; some doom-emacs modules want to change color too
(add-hook 'doom-load-theme-hook #'on-reload-theme t)
; Change background color on frame creation as well
(add-hook 'window-setup-hook (lambda () (process-frame (selected-frame))))
(add-hook 'after-make-frame-functions #'process-frame)

(def-package! company-lsp
  :commands company-lsp
  :config (push 'company-lsp company-backends)
  (setq company-lsp-enable-snippet t))
(def-package! ccls)
(def-package! lsp-ui-flycheck)
(def-package! lsp-mode
  :commands lsp
  :hook ((c-mode c++-mode rust-mode) . lsp)
  :config (setq lsp-enable-snippet t)
  (setq lsp-prefer-flymake nil))
(def-package! lsp-ui)
(set-company-backend! '(c-mode c++-mode cuda-mode objc-mode rust-mode) 'company-lsp)
(def-package! flycheck-clang-tidy
  :after flycheck
  :load-path (lambda () (file-name-directory load-file-name))
  :commands flycheck-clang-tidy-setup
  :config (setq flycheck-clang-tidy-build-path ".")
  :hook ((lsp-mode) . flycheck-clang-tidy-setup))
