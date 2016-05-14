[![License GPL 3][badge-license]](http://www.gnu.org/licenses/gpl-3.0.txt)

# Modern C++ font-lock for Emacs #

Syntax coloring support for "[Modern C++][modern-cpp]" - including C++17 and TS (Technical Specification). It is recommanded to use it in addition with the `c++-mode` major-mode.

## Preview ##

Soon.

## Installation ##

### Manual ###

#### Global setup ####

Download `modern-cpp-font-lock.el` into a directory of your [load-path][load-path]. Place the following lines in a suitable init file:

    (require 'modern-cpp-font-lock)
    (modern-c++-font-lock-global-mode t)

`modern-c++-font-lock-mode` will be activated for buffers using the `c++-mode` major-mode.

#### local ####

For the current buffer, the minor-mode can be turned on/off via the command:

<kbd>M-x modern-c++-font-lock-mode [RET]</kbd>

### Melpa ###

Soon.

Happy coding! :skull:

Lud

[modern-cpp]: https://herbsutter.com/elements-of-modern-c-style/
[load-path]: https://www.gnu.org/software/emacs/manual/html_node/emacs/Lisp-Libraries.html
[badge-license]: https://img.shields.io/badge/license-GPL_3-green.svg
