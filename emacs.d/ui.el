;;; -*- lexical-binding: t -*-

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
(set-frame-font "Source Code Pro 10" nil t)
