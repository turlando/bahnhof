;;; bahnhif-company.el                                -*- lexical-binding: t -*-

(use-package company
  :delight

  :bind (:map company-active-map
         ("C-j" . company-select-next)
         ("C-k" . company-select-previous)
         ("C-h" . company-search-abort)
         ("C-l" . company-complete-selection))

  :hook (prog-mode . company-mode))


(provide 'bahnhof-company)
;;; bahnhof-company.el ends here
