;;; appearance.el --- UI tweaks                       -*- lexical-binding: t -*-

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

;; Set font.
(set-face-attribute 'default nil :font "Source Code Pro" :height 100)

;; Load theme
(load-theme 'arc-dark t)


(provide 'appearance)
;;; appearance.el ends here
