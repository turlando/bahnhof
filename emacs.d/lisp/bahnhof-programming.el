;;; bahnhof-programming.el                            -*- lexical-binding: t -*-

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))


;; Automatically balance parens
(add-hook 'prog-mode-hook 'electric-pair-mode)


(provide 'bahnhof-programming)
;;; bahnhof-programming.el ends here
