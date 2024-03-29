;;; config.el -*- lexical-binding: t; -*-
(setq warning-minimum-level :error)
(setq doom-font (font-spec :family "Iosevka Term" :size 32))
(setq confirm-kill-emacs nil)
(use-package! evil-terminal-cursor-changer
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
    (set-face-background 'solaire-default-face "unspecified-bg" frame)))

(defun on-reload-theme (&rest _)
  (dolist (frame (frame-list))
    (process-frame frame)))

; Change background color on theme reload, append the hook because
; some doom-emacs modules want to change color too
(add-hook 'doom-load-theme-hook #'on-reload-theme t)
; Change background color on frame creation as well
(add-hook 'window-setup-hook (lambda () (process-frame (selected-frame))))
(add-hook 'after-make-frame-functions #'process-frame)
;; (when (getenv "XDG_RUNTIME_DIR")
;;   (setq server-socket-dir (concat (getenv "XDG_RUNTIME_DIR") "/emacs")))

; doom-emacs' +ivy-rich-buffer-name uses common faces like font-lock-comment-face.
; Which is not nice. We override it.
(defface ivy-file-buffer '((t :foreground "white")) "Face for file buffer in ivy-switch-buffer")
(defface ivy-project-file-buffer '((t :inherit ivy-file-buffer)) "Face for project file buffer in ivy-switch-buffer")
(defface ivy-non-file-buffer '((t :foreground "grey")) "Face for non file buffer in ivy-switch-buffer")
(defun my/ivy-rich-buffer-name (candidate)
  "Display the buffer name.

Displays buffers in other projects in `font-lock-doc-face', and
temporary/special buffers in `font-lock-comment-face'."
  (with-current-buffer (get-buffer candidate)
    ; Don't override face when it is already set
    (if (get-text-property 0 'face candidate)
        candidate
      (propertize candidate
                  'face (cond ((string-match-p "^ *\\*" candidate)
                               'ivy-non-file-buffer)
                              ((not buffer-file-name) 'ivy-non-file-buffer)
                              ((file-in-directory-p buffer-file-name
                                                    (or (doom-project-root)
                                                        default-directory))
                               'ivy-project-file-buffer)
                              (t 'ivy-file-buffer))))))
(after! ivy-rich
  (let* ((plist (plist-get ivy-rich-display-transformers-list 'ivy-switch-buffer))
         (colplist (plist-get plist :columns))
         (switch-buffer-alist (assq '+ivy-rich-buffer-name colplist)))
    (when switch-buffer-alist
      (setcar switch-buffer-alist #'my/ivy-rich-buffer-name))))

(use-package! company-lsp
  :commands company-lsp
  :config (push 'company-lsp company-backends)
  (setq company-lsp-enable-snippet t))
(use-package! ccls)
(use-package! lsp-ui-flycheck)
(use-package! lsp-mode
  :commands (lsp lsp-register-client)
  :hook ((c-mode c++-mode rust-mode) . lsp)
  :config (setq lsp-enable-snippet t)
  (setq lsp-prefer-flymake nil))
(use-package! lsp-ui)
(set-company-backend! :derived 'prog-mode '(company-files))
(set-company-backend! 'lsp-mode '(company-lsp))
(use-package! flycheck-clang-tidy
  :after flycheck
  :load-path (lambda () (file-name-directory load-file-name))
  :commands flycheck-clang-tidy-setup
  :config (setq flycheck-clang-tidy-build-path ".")
  :hook ((lsp-mode) . flycheck-clang-tidy-setup))
(advice-add 'lsp-ui-flycheck--report :before (lambda () (flycheck-stop)))

; Load theme after window-setup to make sure customize-set-variable is called
(add-hook 'after-init-hook (lambda () (load-theme 'my-molokai)))
(use-package! elec-pair
  :hook ((c-mode c++-mode rust-mode) . electric-pair-mode))
(use-package! telephone-line
  :config (telephone-line-mode 1))

(define-minor-mode fontify-line-limit-mode
  "Make sure the highlighting doesn't extend beyond the end of line."
  :lighter ""
  :init-value nil
  (font-lock-add-keywords nil '(("\n" . (0 font-lock-function-name-face t))) t))

(define-globalized-minor-mode global-fontify-line-limit-mode
  fontify-line-limit-mode (lambda () (fontify-line-limit-mode t)))
(define-globalized-minor-mode global-save-place-mode
  save-place-mode save-place-mode)

(setq ccls-args '("--log-file=/tmp/ccls.log"))
(global-fontify-line-limit-mode 1)
(setq whitespace-style '(face trailing tabs newline newline-mark tab-mark))
(global-whitespace-mode)
(setq which-key-idle-delay 0.1)

(lsp-register-client
  (make-lsp-client
    :new-connection (lsp-stdio-connection "dls")
    :major-modes '(d-mode)
    :priority -1
    :server-id 'ddls))

(after! rust-mode (set-electric! '(rust-mode) :chars '(?\n ?\})))
(solaire-global-mode 1)

(setq custom-file (concat (file-name-directory load-file-name) "custom.el"))
(load custom-file)
(ranger-override-dired-mode t)
(setq reftex-default-bibliography '("~/bibliography/references.bib"))

;; see org-ref for use of these variables
(setq org-ref-bibliography-notes "~/bibliography/notes.org"
      org-ref-default-bibliography '("~/bibliography/references.bib")
      org-ref-pdf-directory "~/bibliography/bibtex-pdfs/")

(add-to-list 'auto-mode-alist '("\\.adoc\\'" . adoc-mode))
(add-hook 'adoc-mode-hook 'visual-line-mode)
(global-emojify-mode)
(global-save-place-mode)

(defun notmuch-draft--mark-sent ()
    "Tag the last saved draft sent."
    (when notmuch-draft-id
          (notmuch-tag notmuch-draft-id '("+sent"))))

(after! notmuch
 (setq notmuch-saved-searches '((:name "inbox" :query "tag:inbox" :search-type 'tree)
                                (:name "important" :query "tag:important and tag:unread" :search-type 'tree)
                                (:name "unread" :query "tag:inbox and tag:unread")))
 (remove-hook 'message-send-hook 'notmuch-draft--mark-deleted)
 (add-hook 'message-send-hook 'notmuch-draft--mark-sent))

(setq-default message-sendmail-envelope-from 'header)
(setq-default mm-sign-option 'guided)
(setq-default mail-host-address "m5Zedd9JOGzJrf0")
