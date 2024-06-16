;;; flymake-collection-clang-tidy.el --- Clang-tidy diagnostic function -*- lexical-binding: t -*-

;; Copyright (c) 2024 Abdelhak Bougouffa

;; Permission is hereby granted, free of charge, to any person obtaining a copy
;; of this software and associated documentation files (the "Software"), to deal
;; in the Software without restriction, including without limitation the rights
;; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
;; copies of the Software, and to permit persons to whom the Software is
;; furnished to do so, subject to the following conditions:

;; The above copyright notice and this permission notice shall be included in all
;; copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
;; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
;; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
;; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
;; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
;; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;; SOFTWARE.

;;; Commentary:

;; `flymake' static checker for C/C++ using "clang-tidy".
;; Inspired by `flycheck-clang-tidy' - https://github.com/ch1bo/flycheck-clang-tidy

;;; Code:

(require 'flymake)
(require 'flymake-collection)

(eval-when-compile
  (require 'flymake-collection-define))

;;; Custom variables

(defcustom flymake-collection-clang-tidy-build-path "build"
  "Clang build directory."
  :type '(choice (const nil) directory)
  :group 'flymake-collection)

(defcustom flymake-collection-clang-tidy-extra-options nil
  "Extra options to pass to Clang-tidy."
  :type '(choice (const nil) (repeat string))
  :group 'flymake-collection)

;;; Helpers

(defun flymake-clang-tidy-find-project-root (_checker)
  "Find the project root for CHECKER.
This uses `project', `projectile', `vc' or the \".clang-tidy\" file"
  (or
   (when (and (bound-and-true-p projectile-mode) (fboundp 'projectile-project-root))
     (projectile-project-root))
   (and (project-current) (project-root (project-current)))
   (vc-root-dir)
   (locate-dominating-file (or buffer-file-name default-directory) ".clang-tidy")
   (progn
     (message "Could not determine project root, trying current directory.")
     (file-name-directory buffer-file-name))))

(defun flymake-collection-clang-tidy-get-config ()
  "Find and read .clang-tidy."
  (when-let* ((config-dir (locate-dominating-file (or buffer-file-name default-directory) ".clang-tidy"))
              (config-file (expand-file-name ".clang-tidy" config-dir)))
    (with-temp-buffer
      (insert-file-contents config-file)
      (buffer-string))))

;;;###autoload (autoload 'flymake-collection-clang-tidy "flymake-collection-clang-tidy")
(flymake-collection-define-rx flymake-collection-clang-tidy
  "Clang-based C++ linter tool."
  :pre-let ((clang-tidy-exec (executable-find "clang-tidy")))
  :pre-check (unless clang-tidy-exec (error "Cannot find clang-tidy executable"))
  :write-type 'file
  :command (append
            (list clang-tidy-exec)
            (when flymake-collection-clang-tidy-build-path (list "-p" flymake-collection-clang-tidy-build-path))
            (when buffer-file-name (list (concat "-extra-arg=-I" (file-name-directory buffer-file-name))))
            (when (flymake-collection-clang-tidy-get-config) (list (concat "-config=" (flymake-collection-clang-tidy-get-config))))
            (ensure-list flymake-collection-clang-tidy-extra-options)
            (list flymake-collection-temp-file))
  :regexps
  ((error bol (file-name) ":" line ":" column ": error:" (message) eol)
   (warning bol (file-name) ":" line ":" column ": warning:" (message) eol)
   (note bol (file-name) ":" line ":" column ": note:" (message) eol)))


(provide 'flymake-collection-clang-tidy)

;;; flymake-collection-clang-tidy.el ends here
