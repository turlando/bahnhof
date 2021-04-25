;;; init.el --- Configuration entrypoint              -*- lexical-binding: t -*-

;;; Paths definitions

;; Emacs config directory path.
;;
;; If you run emacs normally it the same as user-emacs-directory, whose
;; value is "~/emacs.d".
;;
;; If you want to source the config from a different path (i.e. for
;; testing purposes) you can run "emacs --no-init-file --load init.el".
;;
;; In this case the value of bahnhof-user-emacs-directory is the path
;; to the directory holding the init.el file.
(setq bahnhof-user-emacs-directory (file-name-directory load-file-name))

;; Custom load path.
(setq bahnhof-load-path (expand-file-name "lisp" bahnhof-user-emacs-directory))

;;; Paths configuration
(add-to-list 'load-path bahnhof-load-path)

;;; Import submodules

(require 'bahnhof-packaging)
(require 'bahnhof-appearance)
(require 'bahnhof-ivy)
(require 'bahnhof-programming)

;;; init.el ends here
