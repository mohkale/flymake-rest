;;; flymake-collection-pyre.el --- pyre diagnostic function -*- lexical-binding: t -*-

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

;; `flymake' type-checker for Python 3 using "pyre".

;;; Code:

(require 'flymake)
(require 'flymake-collection)

(eval-when-compile
  (require 'flymake-collection-define))


;;;###autoload (autoload 'flymake-collection-pyre "flymake-collection-pyre")
(flymake-collection-define-rx flymake-collection-pyre
  "Performant type-checking for python."
  :title "pyre"
  :pre-let ((pyre-exec (executable-find "pyre")))
  :pre-check (unless pyre-exec (error "Cannot find pyre in PATH"))
  :write-type 'file
  :command `(,pyre-exec)
  :regexps
  ((warning bol (file-name) ":" line ":" column " " (message) eol)))


(provide 'flymake-collection-pyre)

;;; flymake-collection-pyre.el ends here
