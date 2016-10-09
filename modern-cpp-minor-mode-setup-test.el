;;; modern-cpp-minor-mode-test-setup.el --- Setup and execute all tests

;;; Commentary:

;; This package sets up a suitable enviroment for testing
;; modern-cpp-minor-mode, and executes the tests.
;;
;; Usage:
;;
;;   emacs -q -l modern-cpp-minor-mode-test-setup.el
;;
;; Note that this package assumes that some packages are located in
;; specific locations.

;;; Code:

(prefer-coding-system 'utf-8)

(defvar modern-cpp-minor-mode-test-setup-directory
  (if load-file-name
      (file-name-directory load-file-name)
    default-directory))

(dolist (dir '("." "./faceup"))
  (add-to-list 'load-path
               (concat modern-cpp-minor-mode-test-setup-directory dir)))

(require 'modern-cpp-minor-mode)
(add-hook 'text-mode-hook #'modern-c++-minor-mode)

(require 'modern-cpp-minor-mode-test)

(ert t)

;;; modern-cpp-minor-mode-test-setup.el ends here
