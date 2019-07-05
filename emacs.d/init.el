;;; -*- lexical-binding: t -*-

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

(load (expand-file-name "ui.el" bahnhof-user-emacs-directory))
