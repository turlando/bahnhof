;;; bahnhof-programming.el                            -*- lexical-binding: t -*-

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package highlight-indent-guides
  :delight

  :custom
  (highlight-indent-guides-responsive 'top)
  (highlight-indent-guides-method     'bitmap))


;; Automatically balance parens
(add-hook 'prog-mode-hook 'electric-pair-mode)


(provide 'bahnhof-programming)
;;; bahnhof-programming.el ends here
