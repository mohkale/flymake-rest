;;; flymake-collection-oxlint.el --- OXLint diagnostic function -*- lexical-binding: t -*-

;; Copyright (c) 2024 Eki Zhang

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

;; `flymake' syntax and style checker for Javascript using oxlint.

;;; Code:

(require 'flymake)
(require 'flymake-collection)

(eval-when-compile
  (require 'flymake-collection-define))

;;;###autoload (autoload 'flymake-collection-oxlint "flymake-collection-oxlint")
(flymake-collection-define-enumerate flymake-collection-oxlint
  "A Javascript syntax and style checker using oxlint.

See URL `https://oxc-project.github.io/'."
  :title "oxlint"
  :pre-let ((oxlint-exec (executable-find "oxlint"))
            (file-name (or (buffer-file-name flymake-collection-source)
                           ".")))
  :pre-check (unless oxlint-exec
               (error "Cannot find oxlint executable"))
  :write-type 'pipe
  :command (list oxlint-exec
                 "--format=json"
                 file-name)
  :generator
  (caar
    (flymake-collection-parse-json
     (buffer-substring-no-properties
      (point-min) (point-max))))
  :enumerate-parser
  (let-alist it
    (let* ((start-loc (alist-get 'offset (cdaar .labels)))
           (loc (cons start-loc (+ start-loc (alist-get 'length (cdaar .labels))))))
      (list flymake-collection-source
            (car loc)
            (cdr loc)
            (pcase .severity
              ("error" :error)
              ("warning" :warning)
              (_ :note))
            .message))))

(provide 'flymake-collection-oxlint)

;;; flymake-collection-oxlint.el ends here
