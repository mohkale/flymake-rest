;;; flymake-collection-bashate.el --- Bashate diagnostic function -*- lexical-binding: t -*-

;; Copyright (C) 2024 James Cherti | https://www.jamescherti.com/contact/

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

;; `flymake' style checker for bash scripts using bashate.

;;; Code:

(require 'flymake)
(require 'flymake-collection)

(eval-when-compile
  (require 'flymake-collection-define))

;;;###autoload (autoload 'flymake-collection-bashate "flymake-collection-bashate")
(flymake-collection-define-rx flymake-collection-bashate
  "A Bash style checker using bashate.
See URL `https://github.com/openstack/bashate`."
  :title "bashate"
  :pre-let ((bashate-exec (executable-find "bashate")))
  :pre-check (unless bashate-exec
               (error "The bashate executable was not found"))
  :write-type 'file
  :command `(,bashate-exec
             ,flymake-collection-temp-file)
  :regexps
  ((error bol (file-name) ":" line ":" column
          ": " (id (one-or-more alnum)) " " (message) eol)))

(provide 'flymake-collection-bashate)

;;; flymake-collection-bashate.el ends here
