;;; flymake-collection-janet.el --- Janet diagnostic function -*- lexical-binding: t -*-

;; Copyright (c) 2024 Tomasz Hołubowicz

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

;; `flymake' syntax checker for Janet using janet flycheck utility

;;; Code:

(require 'flymake)
(require 'flymake-collection)

(eval-when-compile
  (require 'flymake-collection-define))

;;;###autoload (autoload 'flymake-collection-janet "flymake-collection-janet")
(flymake-collection-define-rx flymake-collection-janet
  "A Janet syntax checker using janet flycheck utility.

See URL `https://janet-lang.org/"
  :pre-let ((janet-exec (executable-find "janet")))
  :pre-check (unless janet-exec (user-error "Cannot find janet executable"))
  :write-type 'pipe
  :command `(,janet-exec "-k")
  :regexps
  ((error bol "error: stdin:" line ":" column ": " (message) eol)))

(provide 'flymake-collection-janet)

;;; flymake-collection-janet.el ends here
