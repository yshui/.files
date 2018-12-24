;; -*- origami-fold-style: triple-braces -*-
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(add-to-list 'load-path "~/.emacs.d/lisp")
(straight-use-package 'use-package)

;{{{
(use-package evil
             :straight t)
(use-package helm
             :straight t)
(use-package evil-terminal-cursor-changer
             :straight t)
(use-package doom-themes
             :straight t)
(use-package lsp-ui
             :straight t
             :commands lsp-ui-mode)
(use-package lsp-mode
             :straight t
             :commands lsp)
(use-package ccls
             :straight t)
(use-package company
             :straight t)
(use-package company-lsp
             :straight t)
(use-package projectile
             :straight t)
(use-package helm-projectile
             :straight t)
(use-package helm-descbinds
             :straight t)
(use-package helm-ag
             :straight t)
(use-package origami
             :straight t)
;}}}
(require 'helm-everywhere)

(projectile-mode +1)
(global-origami-mode 1)

(load-theme 'doom-molokai t)
(evil-mode 1)
(unless (display-graphic-p)
        (evil-terminal-cursor-changer-activate) ; or (etcc-on)
)
(setq evil-motion-state-cursor 'box)  ; █
(setq evil-visual-state-cursor 'box)  ; █
(setq evil-normal-state-cursor 'box)  ; █
(setq evil-insert-state-cursor 'bar)  ; ⎸
(setq evil-emacs-state-cursor  'hbar) ; _')
(defun on-after-init ()
  (unless (display-graphic-p (selected-frame))
    (set-face-background 'default "unspecified-bg" (selected-frame))))

(add-hook 'window-setup-hook 'on-after-init)
(setq backup-directory-alist `(("." . "~/.emacs-bkups")))
(setq backup-by-copying t)
(setq delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)
(save-place-mode 1)
(add-hook 'c-mode-hook #'lsp)
(add-hook 'after-init-hook 'global-company-mode)
(push 'company-lsp company-backends)
;(menu-bar-mode -1)
(xterm-mouse-mode 1)
(setq custom-file "~/.emacs.d/lisp/custom.el")
(load custom-file)
(setq scroll-conservatively 10000)
; vim: set et ts=2 sw=2 :
