;;; flymake-collection-kube-linter.el --- Linter for k8s configs -*- lexical-binding: t -*-

;; Copyright (c) 2024 Mohsin Kaleem

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

;; `flymake' syntax checker for kubernetes configuration files.

;;; Code:

(require 'flymake)
(require 'flymake-collection)
(eval-when-compile (require 'subr-x))

(eval-when-compile
  (require 'flymake-collection-define))

;;;###autoload (autoload 'flymake-collection-kube-linter "flymake-collection-kube-linter")
(flymake-collection-define-enumerate flymake-collection-kube-linter
  "KubeLinter is a static analysis tool that checks Kubernetes YAML files and Helm
charts to ensure the applications represented in them adhere to best practices.

https://docs.kubelinter.io/#/"
  :title "kube-linter"
  :pre-let ((kube-linter-exec (executable-find "kube-linter")))
  :pre-check (unless kube-linter-exec
               (error "Cannot find kube-linter executable"))
  :write-type 'pipe
  :command `(,kube-linter-exec
             "lint"
             "--fail-if-no-objects-found"
             "--fail-on-invalid-resource"
             "--format=json"
             "-")
  :generator
  (thread-last
    (flymake-collection-parse-json
     (buffer-substring-no-properties
      (point-min) (point-max)))
    (car)
    (alist-get 'Reports))
  :enumerate-parser
  (let-alist it
    `(,flymake-collection-source
      ,@(with-current-buffer flymake-collection-source
          (list (point-min) (point-max)))
      :error
      ,(concat (propertize (concat "[" .Check "]") 'face 'flymake-collection-diag-id) " "
               .Diagnostic.Message))))

(provide 'flymake-collection-kube-linter)
;;; flymake-collection-kube-linter.el ends here
