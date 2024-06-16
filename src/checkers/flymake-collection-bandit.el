;;; flymake-collection-bandit.el --- bandit diagnostic function -*- lexical-binding: t -*-

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

;; `flymake' checker for common security issues in Python code using "bandit".

;;; Code:

(require 'flymake)
(require 'flymake-collection)

(eval-when-compile
  (require 'flymake-collection-define))

;;;###autoload (autoload 'flymake-collection-bandit "flymake-collection-bandit")
(flymake-collection-define-rx flymake-collection-bandit
  "Find common security issues in Python code."
  :title "bandit"
  :pre-let ((bandit-exec (executable-find "bandit")))
  :pre-check (unless bandit-exec (error "Cannot find bandit executable"))
  :write-type 'file
  :command (list bandit-exec "--format" "custom" "--msg-template" "diag:{line}:{severity}:{test_id}: {msg}" flymake-collection-temp-file)
  :regexps
  ((error   bol "diag:" line ":" "HIGH" ":" (id (* alnum)) ":" (message) eol)
   (warning bol "diag:" line ":" "MEDIUM" ":" (id (* alnum)) ":" (message) eol)
   (note    bol "diag:" line ":" (or "LOW" "UNDEFINED") ":" (id (* alnum)) ":" (message) eol)))


(provide 'flymake-collection-bandit)

;;; flymake-collection-bandit.el ends here
