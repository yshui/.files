;;; flycheck-clang-tidy.el --- Flycheck syntax checker using clang-tidy

;; Author: Sebastian Nagel<sebastian.nagel@ncoding.at>
;; URL: https://github.com/ch1bo/flycheck-clang-tidy
;; Keywords: convenience languages tools
;; Package-Version: 0.0.1
;; Package-Requires: ((flycheck "0.30"))

;; This file is NOT part of GNU Emacs.
;; See LICENSE

;;; Commentary:

;; Adds a Flycheck syntax checker for C/C++ based on clang-tidy.

;;; Usage:

;;     (eval-after-load 'flycheck
;;       '(add-hook 'flycheck-mode-hook #'flycheck-clang-tidy-setup))


;;; Code:

(require 'flycheck)
(require 'seq)
(require 'json)

(flycheck-def-config-file-var flycheck-clang-tidy c/c++-clang-tidy ".clang-tidy"
  :safe #'stringp)

(flycheck-def-option-var flycheck-clang-tidy-build-path "build" c/c++-clang-tidy
  "Build path to read a compile command database.

For example, it can be a CMake build directory in which a file named
compile_commands.json exists (use -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
CMake option to get this output)."
  :safe #'stringp)

(defun flycheck-clang-tidy-find-default-directory (checker)
  (let ((config_file_location (flycheck-locate-config-file flycheck-clang-tidy checker)))
    (if config_file_location
        (file-name-directory config_file_location) default-directory)))

(defun flycheck-clang-tidy-find-root ()
  (if (projectile-project-root) (projectile-project-root) (flycheck-clang-tidy-find-default-directory)))

(defun flycheck-clang-tidy-compile-command (file)
  "Fetch compile command for FILE."
  (let* ((cmds-file (concat (flycheck-clang-tidy-find-root) "/" flycheck-clang-tidy-build-path "/"
                            "compile_commands.json"))
         (cmds (json-read-file cmds-file)))
    (seq-find (lambda (cmd) (string= (expand-file-name (alist-get 'file cmd) (alist-get 'directory cmd)) file)) cmds)))

(defconst flycheck-clang-tidy-bad-arguments (list "-pipe"))
(defconst flycheck-clang-tidy-bad-arguments-dict
  (let ((ret (make-hash-table :test 'equal)))
    (dolist (a flycheck-clang-tidy-bad-arguments)
      (puthash a t ret)) ret))

(defun flycheck-clang-tidy-remove-bad-arguments (cmd)
  (cond ((stringp cmd) (replace-regexp-in-string (mapconcat 'identity flycheck-clang-tidy-bad-arguments "|") "" cmd))
        ((listp cmd) (seq-filter (lambda (x) (not (gethash x flycheck-clang-tidy-bad-arguments-dict nil))) cmd))))


(defun flycheck-clang-tidy-expand-file-name (file)
  "Expand a file name in compile_commands.json to absolute path"
  (let* ((cmds-file (concat (flycheck-clang-tidy-find-root) "/" flycheck-clang-tidy-build-path "/"
                            "compile_commands.json"))
         (cmds (json-read-file cmds-file))
         (cmd (seq-find (lambda (cmd) (string= (alist-get 'file cmd) file)) cmds)))
    (if cmd (expand-file-name (alist-get 'file cmd) (alist-get 'directory cmd)) file)))

(defun flycheck-clang-tidy-temp-compile-command (file source)
  "Return compile command for FILE with source located in SOURCE."
  (let* ((cmd (flycheck-clang-tidy-compile-command file))
         (xfile (alist-get 'file cmd))
         (directory (alist-get 'directory cmd))
         (command (alist-get 'command cmd))
         (args (alist-get 'arguments cmd)))
    (if command (list (cons 'directory directory)
                      (cons 'command (flycheck-clang-tidy-remove-bad-arguments
                                      (replace-regexp-in-string (regexp-quote xfile)
                                                               source command)))
                      (cons 'file source))
      (list (cons 'directory directory)
            (cons 'file source)
            (cons 'arguments (flycheck-clang-tidy-remove-bad-arguments
                              (mapcar (lambda (x) (if (string= x xfile) source x)) args)))))))

(defun flycheck-clang-tidy-make-temp-compile-command (file source)
  "Create a temporary build command file for FILE with SOURCE."
  (let* ((directory (flycheck-temp-dir-system))
         (cmds-dir (file-name-as-directory (make-temp-name (expand-file-name "flycheck" directory))))
         (cmds-file (concat cmds-dir "compile_commands.json"))
         (cmd (flycheck-clang-tidy-temp-compile-command file source)))
    (when cmd
      (prog1 cmds-dir
        (mkdir cmds-dir)
        (with-temp-file cmds-file
          (insert (json-encode (vector cmd))))))))

(defun flycheck-clang-tidy-build-command ()
  "Generate temporary compile_commands.json file.

This functions parses the compile_commands.json file and generate
a new one for the flycheck temporary source file so that
clang-tidy understand what to do with it."
  (let* ((source (flycheck-save-buffer-to-temp #'flycheck-temp-file-system))
         (ccfile (flycheck-clang-tidy-make-temp-compile-command (buffer-file-name)
                                                                source)))
    (remove nil (list (when ccfile (format "-p=%s" ccfile)) source))))

(flycheck-define-checker c/c++-clang-tidy
  "A C/C++ syntax checker using clang-tidy.

See URL `https://github.com/ch1bo/flycheck-clang-tidy'."
  :command ("clang-tidy"
            ;; TODO: clang-tidy expects config file contents, no way to change path
            ;; (config-file "-config=" flycheck-clang-tidy)
            (eval (flycheck-clang-tidy-build-command)))
  :error-patterns
  ((error line-start (file-name) ":" line ":" column ": error: "
          (message) line-end)
   (warning line-start (file-name) ":" line ":" column ": warning: "
            (message) line-end)
   (info line-start (file-name) ":" line ":" column ": note: "
         (message) line-end))
  :modes (c-mode c++-mode)
  :working-directory flycheck-clang-tidy-find-default-directory
  :error-filter (lambda (errors)
                  (dolist (err errors)
                    (setf (flycheck-error-filename err)
                          (flycheck-clang-tidy-expand-file-name (flycheck-error-filename err))))
                  errors))

;;;###autoload
(defun flycheck-clang-tidy-setup ()
  "Setup Flycheck clang-tidy."
  (add-to-list 'flycheck-checkers 'c/c++-clang-tidy)
  (when lsp-mode (flycheck-add-next-checker 'lsp-ui '(warning . c/c++-clang-tidy))))

(provide 'flycheck-clang-tidy)
;;; flycheck-clang-tidy.el ends here
