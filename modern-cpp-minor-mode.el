;;; modern-cpp-minor-mode.el --- Font-locking for "Modern C++"  -*- lexical-binding: t; -*-

;; Copyright © 2016, by Ludwig PACIFICI

;; Authors: Ludwig PACIFICI <ludwig@lud.cc>, Duzy Chan <code@duzy.info>
;; URL: https://github.com/ludwigpacifici/modern-cpp-minor-mode
;; Version: 0.1.3
;; Created: 12 May 2016
;; Keywords: languages, c++, cpp, font-lock

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Syntax highlighting support for "Modern C++" - until C++17 and
;; Technical Specification. This package aims to provide a simple
;; highlight of the C++ language without dependency.

;; It is recommended to use it in addition with the c++-mode major
;; mode for extra highlighting (user defined types, functions, etc.)
;; and indentation.

;; Melpa: [M-x] package-install [RET] modern-cpp-minor-mode [RET]
;; In your init Emacs file add:
;;     (add-hook 'c++-mode-hook #'modern-c++-minor-mode)
;; or:
;;     (modern-c++-minor-mode-global-mode t)

;; For the current buffer, the minor-mode can be turned on/off via the
;; command:
;;     [M-x] modern-c++-minor-mode [RET]

;; More documentation:
;; https://github.com/ludwigpacifici/modern-cpp-minor-mode/blob/master/README.md

;; Feedback is welcome!

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

(defgroup modern-c++-minor-mode nil
  "Provides font-locking as a Minor Mode for Modern C++"
  :group 'faces)

(eval-and-compile
  (defun modern-c++-string-lenght< (a b) (< (length a) (length b)))
  (defun modern-c++-string-lenght> (a b) (not (modern-c++-string-lenght< a b))))

(defcustom modern-c++-comment-todos
  (eval-when-compile
    (sort '("TODO" "FIXME")
          'modern-c++-string-lenght>))
  "TODO, FIXME in comments"
  :type '(choice (const :tag "Disabled" nil)
                 (repeat string))
  :group 'modern-c++-minor-mode)

(defcustom modern-c++-types
  (eval-when-compile
    (sort '("bool" "char" "char16_t" "char32_t" "double" "float" "int" "long" "short" "signed" "unsigned" "void" "wchar_t")
          'modern-c++-string-lenght>))
  "List of C++ types. See doc:
http://en.cppreference.com/w/cpp/language/types"
  :type '(choice (const :tag "Disabled" nil)
                 (repeat string))
  :group 'modern-c++-minor-mode)

(defcustom modern-c++-preprocessors
  (eval-when-compile
    (sort '("#define" "#defined" "#elif" "#else" "#endif" "#error" "#if" "#ifdef" "#ifndef" "#include" "#line" "#pragma STDC CX_LIMITED_RANGE" "#pragma STDC FENV_ACCESS" "#pragma STDC FP_CONTRACT" "#pragma once" "#pragma pack" "#pragma" "#undef" "_Pragma" "__DATE__" "__FILE__" "__LINE__" "__STDCPP_STRICT_POINTER_SAFETY__" "__STDCPP_THREADS__" "__STDC_HOSTED__" "__STDC_ISO_10646__" "__STDC_MB_MIGHT_NEQ_WC__" "__STDC_VERSION__" "__STDC__" "__TIME__" "__VA_AR_GS__" "__cplusplus" "__has_include")
          'modern-c++-string-lenght>))
  "List of C++ preprocessor words. See doc:
http://en.cppreference.com/w/cpp/keyword and
http://en.cppreference.com/w/cpp/preprocessor"
  :type '(choice (const :tag "Disabled" nil)
                 (repeat string))
  :group 'modern-c++-minor-mode)

(defcustom modern-c++-keywords
  (eval-when-compile
    (sort '("alignas" "alignof" "and" "and_eq" "asm" "atomic_cancel" "atomic_commit" "atomic_noexcept" "auto" "bitand" "bitor" "break" "case" "catch" "class" "compl" "concept" "const" "const_cast" "constexpr" "continue" "decltype" "default" "delete" "do" "dynamic_cast" "else" "enum" "explicit" "export" "extern" "final" "for" "friend" "goto" "if" "import" "inline" "module" "mutable" "namespace" "new" "noexcept" "not" "not_eq" "operator" "or" "or_eq" "override" "private" "protected" "public" "register" "reinterpret_cast" "requires" "return" "sizeof" "sizeof..." "static" "static_assert" "static_cast" "struct" "switch" "synchronized" "template" "this" "thread_local" "throw" "transaction_safe" "transaction_safe_dynamic" "try" "typedef" "typeid" "typename" "union" "using" "virtual" "volatile" "while" "xor" "xor_eq")
          'modern-c++-string-lenght>))
  "List of C++ keywords. See doc:
http://en.cppreference.com/w/cpp/keyword"
  :type '(choice (const :tag "Disabled" nil)
                 (repeat string))
  :group 'modern-c++-minor-mode)

(defcustom modern-c++-attributes
  (eval-when-compile
    (sort '("carries_dependency" "deprecated" "fallthrough" "maybe_unused" "nodiscard" "noreturn" "optimize_for_synchronized")
          'modern-c++-string-lenght>))
  "List of C++ attributes. See doc:
http://en.cppreference.com/w/cpp/language/attributes"
  :type '(choice (const :tag "Disabled" nil)
                 (repeat string))
  :group 'modern-c++-minor-mode)

(defcustom modern-c++-operators
  (eval-when-compile
    (sort '("...")
          'modern-c++-string-lenght>))
  "List of C++ assignment operators. Left Intentionally almost
empty. The user will choose what should be font-locked. By
default I want to avoid a 'christmas tree' C++ code. For more
information, see doc:
http://en.cppreference.com/w/cpp/language/operators"
  :type '(choice (const :tag "Disabled" nil)
                 (repeat string))
  :group 'modern-c++-minor-mode)

(defvar modern-c++-minor-mode-keywords nil)

(defun modern-c++-generate-font-lock-comment-todos ()
  (let ((todos-regexp (concat (regexp-opt modern-c++-comment-todos 'words) ":")))
    (setq modern-c++-minor-mode-comment-todos
          `(
            ;; Uses warning-face (use prepend to highlight todos in comments)
            (,todos-regexp (1 font-lock-warning-face prepend))
            ))))

(defun modern-c++-generate-font-lock-keywords ()
  (let ((types-regexp (regexp-opt modern-c++-types 'words))
        (preprocessors-regexp (regexp-opt modern-c++-preprocessors))
        (keywords-regexp (regexp-opt modern-c++-keywords 'words))
        (attributes-regexp
         (concat "\\[\\[\\(" (regexp-opt modern-c++-attributes 'words) "\\).*\\]\\]"))
        (operators-regexp (regexp-opt modern-c++-operators)))
    (setq modern-c++-minor-mode-keywords
          `(
            ;; Note: order below matters, because once colored, that part
            ;; won't change. In general, longer words first
            (,types-regexp (0 font-lock-type-face))
            (,preprocessors-regexp (0 font-lock-preprocessor-face))
            (,attributes-regexp (1 font-lock-constant-face))
            (,operators-regexp (0 font-lock-function-name-face))
            (,keywords-regexp (0 font-lock-keyword-face))))))

(defcustom modern-c++-literal-boolean
  t
  "Enable font-lock for boolean literals. For more information,
see documentation:
http://en.cppreference.com/w/cpp/language/bool_literal"
  :type 'boolean
  :group 'modern-c++-minor-mode)

(defvar modern-c++-minor-mode-literal-boolean nil)

(defun modern-c++-generate-font-lock-literal-boolean ()
  (let ((literal-boolean-regexp (regexp-opt
                                 (eval-when-compile (sort '("false" "true") 'modern-c++-string-lenght>))
                                 'words)))
    (setq modern-c++-minor-mode-literal-boolean
          `(
            ;; Note: order below matters, because once colored, that part
            ;; won't change. In general, longer words first
            (,literal-boolean-regexp (0 font-lock-constant-face))))))

(defcustom modern-c++-literal-integer
  t
  "Enable font-lock for integer literals. For more information,
see documentation:
http://en.cppreference.com/w/cpp/language/integer_literal"
  :type 'boolean
  :group 'modern-c++-minor-mode)

(defvar modern-c++-minor-mode-literal-integer nil)

(defun modern-c++-generate-font-lock-literal-integer ()
  (eval-when-compile
    (let* ((integer-suffix-regexp (regexp-opt (sort '("ull" "LLu" "LLU" "llu" "llU" "uLL" "ULL" "Ull" "ll" "LL" "ul" "uL" "Ul" "UL" "lu" "lU" "LU" "Lu" "u" "U" "l" "L") 'modern-c++-string-lenght>)))
           (not-alpha-numeric-regexp "[^0-9a-zA-Z'\\\.]")
           (literal-binary-regexp (concat not-alpha-numeric-regexp "\\(0[bB]\\)\\([01']+\\)\\(" integer-suffix-regexp "?\\)"))
           (literal-octal-regexp (concat not-alpha-numeric-regexp "\\(0\\)\\([0-7']+\\)\\(" integer-suffix-regexp "?\\)"))
           (literal-hex-regexp (concat not-alpha-numeric-regexp "\\(0[xX]\\)\\([0-9a-fA-F']+\\)\\(" integer-suffix-regexp "?\\)"))
           (literal-dec-regexp (concat not-alpha-numeric-regexp "\\([1-9][0-9']*\\)\\(" integer-suffix-regexp "\\)")))
      (setq modern-c++-minor-mode-literal-integer
            `(
              ;; Note: order below matters, because once colored, that part
              ;; won't change. In general, longer words first
              (,literal-binary-regexp (1 font-lock-keyword-face)
                                      (2 font-lock-constant-face)
                                      (3 font-lock-keyword-face))
              (,literal-octal-regexp (1 font-lock-keyword-face)
                                     (2 font-lock-constant-face)
                                     (3 font-lock-keyword-face))
              (,literal-hex-regexp (1 font-lock-keyword-face)
                                   (2 font-lock-constant-face)
                                   (3 font-lock-keyword-face))
              (,literal-dec-regexp (1 font-lock-constant-face)
                                   (2 font-lock-keyword-face)))))))

(defcustom modern-c++-literal-null-pointer
  t
  "Enable font-lock for null pointer literals. For more information,
see documentation:
http://en.cppreference.com/w/cpp/language/nullptr"
  :type 'boolean
  :group 'modern-c++-minor-mode)

(defvar modern-c++-minor-mode-literal-null-pointer nil)

(defun modern-c++-generate-font-lock-literal-null-pointer ()
  (let ((literal-null-pointer-regexp (regexp-opt
                                      (eval-when-compile (sort '("nullptr") 'modern-c++-string-lenght>))
                                      'words)))
    (setq modern-c++-minor-mode-literal-null-pointer
          `(
            ;; Note: order below matters, because once colored, that part
            ;; won't change. In general, longer words first
            (,literal-null-pointer-regexp (0 font-lock-constant-face))))))

(defcustom modern-c++-literal-string
  t
  "Enable font-lock for string literals. For more information,
see documentation:
http://en.cppreference.com/w/cpp/language/string_literal"
  :type 'boolean
  :group 'modern-c++-minor-mode)

(defvar modern-c++-minor-mode-literal-string nil)

(defun modern-c++-generate-font-lock-literal-string ()
  (eval-when-compile
    (let* ((simple-string-regexp "\"[^\"]*\"")
           (raw "R")
           (prefix-regexp
            (regexp-opt (sort '("L" "u8" "u" "U") 'modern-c++-string-lenght>)))
           (literal-string-regexp
            (concat "\\(" prefix-regexp "?\\)\\(" simple-string-regexp "\\)\\(s?\\)"))
           (delimiter-group-regexp "\\([^\\s-\\\\()]\\{1,16\\}\\)")
           (raw-delimiter-literal-string-regexp
            (concat "\\(" prefix-regexp "?" raw
                    "\"" delimiter-group-regexp "(\\)"
                    "\\(\\(.\\|\n\\)*?\\)"
                    "\\()\\2\"s?\\)"))
           (raw-literal-string-regexp
            (concat "\\(" prefix-regexp "?" raw "\"(\\)"
                    "\\(\\(.\\|\n\\)*?\\)"
                    "\\()\"s?\\)")))
      (setq modern-c++-minor-mode-literal-string
            `(
              ;; Note: order below matters, because once colored, that part
              ;; won't change. In general, longer words first
              (,raw-delimiter-literal-string-regexp (1 font-lock-constant-face)
                                                    (3 font-lock-string-face)
                                                    (5 font-lock-constant-face))
              (,raw-literal-string-regexp (1 font-lock-constant-face)
                                          (2 font-lock-string-face)
                                          (4 font-lock-constant-face))
              (,literal-string-regexp (1 font-lock-constant-face)
                                      (2 font-lock-string-face)
                                      (3 font-lock-constant-face)))))))

(defun modern-c++-minor-mode-add-keywords (&optional mode)
  "Install keywords into major MODE, or into current buffer if nil."
  (font-lock-add-keywords mode (modern-c++-generate-font-lock-comment-todos) nil)
  (font-lock-add-keywords mode (modern-c++-generate-font-lock-keywords) nil)
  (when modern-c++-literal-boolean
    (font-lock-add-keywords mode (modern-c++-generate-font-lock-literal-boolean) nil))
  (when modern-c++-literal-integer
    (font-lock-add-keywords mode (modern-c++-generate-font-lock-literal-integer) nil))
  (when modern-c++-literal-null-pointer
    (font-lock-add-keywords mode (modern-c++-generate-font-lock-literal-null-pointer) nil))
  (when modern-c++-literal-string
    (font-lock-add-keywords mode (modern-c++-generate-font-lock-literal-string) nil)))

(defun modern-c++-minor-mode-remove-keywords (&optional mode)
  "Remove keywords from major MODE, or from current buffer if nil."
  (font-lock-remove-keywords mode modern-c++-minor-mode-comment-todos)
  (font-lock-remove-keywords mode modern-c++-minor-mode-keywords)
  (when modern-c++-literal-boolean
    (font-lock-remove-keywords mode modern-c++-minor-mode-literal-boolean))
  (when modern-c++-literal-integer
    (font-lock-remove-keywords mode modern-c++-minor-mode-literal-integer))
  (when modern-c++-literal-null-pointer
    (font-lock-remove-keywords mode modern-c++-minor-mode-literal-null-pointer))
  (when modern-c++-literal-string
    (font-lock-remove-keywords mode modern-c++-minor-mode-literal-string)))

(defun modern-c++-inside-class-enum-p (pos)
  "Checks if POS is within the braces of a C++ \"enum class\"."
  (ignore-errors
    (save-excursion
      (goto-char pos)
      (up-list -1) ; Move forward out of one level of parentheses.
      (backward-sexp 1) ; Move backward across 1 balanced expression (sexp).
      (or (looking-back "enum\\s-+class\\s-+")
          (looking-back "enum\\s-+class\\s-+\\S-+\\s-*:\\s-*")))))

(defun modern-c++-argument-lambda-p (pos)
  "Checks if POS is at the beginning of a lambda as argument."
  (ignore-errors
    (save-excursion
      (goto-char pos)
      (looking-at ".*[(,][ \t]*\\[[^]]*\\][ \t]*[({][^}]*$"))))

(defun modern-c++-argument-block-p (pos)
  "Checks if POS is at the beginning of a block as argument."
  (ignore-errors
    (save-excursion
      (goto-char pos)
      (if (not (looking-at (regexp-opt (list "if" "while" "for") 'words)))
          (or (looking-at ".*[(,][^)]*[({][^}]*$")
              nil)))))

(defun modern-c++-argument-block-closed-p (pos)
  "Checks if POS is at a block as argument."
  (ignore-errors
    (save-excursion
      (goto-char pos)
      (if (not (looking-at (regexp-opt (list "if" "while" "for") 'words)))
          (or (looking-at ".*[({].*[})]\\s-*,$")
              nil)))))

(defun modern-c++-class-enum-closing-brace-p (pos)
  "Checks if POS is within the braces of a C++ \"enum class\"."
  (ignore-errors
    (save-excursion
      ;;(goto-char pos)
      (move-beginning-of-line 1)
      (or (looking-at "\\s-*}")))))

(defun modern-c++-offset-topmost-intro-cont (langelem)
  (let ((pos (c-langelem-pos langelem)))
    (cond 
     ((modern-c++-inside-class-enum-p pos)
      (cond
       ((modern-c++-class-enum-closing-brace-p pos) '-)
       (t 0)))
     (t (c-lineup-topmost-intro-cont langelem)))))

(defun modern-c++-offset-statement (langelem)
  (let ((pos (c-langelem-pos langelem)))
    (cond
     (t (message (buffer-substring pos (+ pos 10))) 0))))

(defun modern-c++-offset-statement-cont (langelem)
  (let ((pos (c-langelem-pos langelem)))
    (cond
     ((modern-c++-inside-class-enum-p pos) '-)
     ((modern-c++-argument-block-p pos) 
      (message (concat "argument-block: " (buffer-substring pos (+ pos 10))))
      '-)
     ((modern-c++-argument-block-closed-p pos) 
      (message (concat "argument-block-closed: " (buffer-substring pos (+ pos 10))))
      '-)
     (t (message (buffer-substring pos (+ pos 10))) '+))))

(defun modern-c++-offset-statement-block-intro (langelem)
  (let ((pos (c-langelem-pos langelem)))
    (cond 
     ((modern-c++-argument-lambda-p pos) 
      (message (concat "argument-lambda: " (buffer-substring pos (+ pos 10))))
      0)
     ((modern-c++-argument-block-p pos) 
      (message (concat "argument-block: " (buffer-substring pos (+ pos 10))))
      0)
     (t (message (buffer-substring pos (+ pos 10))) '+))))

(defun modern-c++-offset-substatement-open (langelem)
  (let ((pos (c-langelem-pos langelem)))
    (cond
     ((modern-c++-argument-block-closed-p pos) 
      (message (concat "argument-block-closed: " (buffer-substring pos (+ pos 10))))
      0)
     (t (message (buffer-substring pos (+ pos 10))) 0))))

(defun modern-c++-offset-block-close (langelem)
  (let ((pos (c-langelem-pos langelem)))
    (cond
     ((modern-c++-argument-lambda-p pos) 
      (message (concat "argument-lambda: " (buffer-substring pos (+ pos 10))))
      '-)
     ((modern-c++-argument-block-p pos) 
      (message (concat "argument-block: " (buffer-substring pos (+ pos 10))))
      '-)
     (t (message (buffer-substring pos (+ pos 10))) 0))))

(defun modern-c++-setup-indentations ()
  "Deal with modern C++ identations"
  ;; +   `c-basic-offset' times 1
  ;; -   `c-basic-offset' times -1
  ;; ++  `c-basic-offset' times 2
  ;; --  `c-basic-offset' times -2
  ;; *   `c-basic-offset' times 0.5
  ;; /   `c-basic-offset' times -0.5
  (add-to-list 'c-offsets-alist '(topmost-intro-cont . modern-c++-offset-topmost-intro-cont))
  (add-to-list 'c-offsets-alist '(statement-block-intro . modern-c++-offset-statement-block-intro))
  (add-to-list 'c-offsets-alist '(statement . modern-c++-offset-statement))
  (add-to-list 'c-offsets-alist '(statement-cont . modern-c++-offset-statement-cont))
  (add-to-list 'c-offsets-alist '(substatement-open . modern-c++-offset-substatement-open))
  (add-to-list 'c-offsets-alist '(block-close . modern-c++-offset-block-close)) 
  t)

;;;###autoload
(define-minor-mode modern-c++-minor-mode
  "Provides font-locking as a Minor Mode for Modern C++"
  :init-value nil
  :lighter " mc++"
  :group 'modern-c++-minor-mode
  (if modern-c++-minor-mode
      (modern-c++-minor-mode-add-keywords)
    (modern-c++-minor-mode-remove-keywords))

  ;; (setq-default
  ;;  c-basic-offset 4
  ;;  tab-width 4
  ;;  indent-tabs-mode t)

  ;; As of Emacs 24.4, `font-lock-fontify-buffer' is not legal to
  ;; call, instead `font-lock-flush' should be used.
  (if (fboundp 'font-lock-flush)
      (font-lock-flush)
    (when font-lock-mode
      (with-no-warnings
        (font-lock-fontify-buffer))))

  (modern-c++-setup-indentations))

;;;###autoload
(define-global-minor-mode modern-c++-minor-mode-global-mode modern-c++-minor-mode
  (lambda ()
    (when (apply 'derived-mode-p '(c++-mode))
      (modern-c++-minor-mode 1)))
  :group 'modern-c++-minor-mode)

(provide 'modern-cpp-minor-mode)

;; coding: utf-8

;;; modern-cpp-minor-mode.el ends here
