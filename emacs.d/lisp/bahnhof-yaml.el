;;; bahnhof-yaml.el                                   -*- lexical-binding: t -*-

(use-package highlight-indent-guides
  :delight

  :custom
  (highlight-indent-guides-responsive 'top)
  (highlight-indent-guides-method     'bitmap))

(use-package yaml-mode
  :hook (yaml-mode . highlight-indent-guides-mode))


(provide 'bahnhof-yaml)
;;; bahnhof-yaml.el ends here
