;;; bahnhof-appearance.el                             -*- lexical-binding: t -*-

;;; Disable default UI components

;; Disable scroll bars.
(scroll-bar-mode -1)

;; Remove upper toolbar with File/Edit/etc menus.
(tool-bar-mode -1)

;; Remove upper buttons toolbar.
(menu-bar-mode -1)

;; Disable help tooltips showing when hovering items.
(tooltip-mode -1)

;; Don't show *GNU Emacs* buffer at startup.
(setq inhibit-startup-screen t)


;;; Theme

;; Install theme
(use-package spacemacs-theme
  :defer t ; otherwise it will load spacemacs-theme which does not exist
  :init (load-theme 'spacemacs-dark t))


;;; Font

;; Set font.
(set-face-attribute 'default nil
                    :font "Source Code Pro"
                    :height 100)


;;; Mode line

;; Show column number in the mode line
(column-number-mode)


(provide 'bahnhof-appearance)
;;; bahnhof-appearance.el ends here
