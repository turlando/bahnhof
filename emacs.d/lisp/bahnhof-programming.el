;;; bahnhof-programming.el                            -*- lexical-binding: t -*-

(use-package editorconfig
  :ensure t
  :delight
  :config
  (editorconfig-mode 1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; Highlight closing or opening parens
(add-hook 'prog-mode-hook 'show-paren-mode)

;; Automatically balance parens
(add-hook 'prog-mode-hook 'electric-pair-mode)


(provide 'bahnhof-programming)
;;; bahnhof-programming.el ends here
