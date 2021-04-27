;;; bahnhof-helpful.el                                -*- lexical-binding: t -*-

(use-package helpful
  :requires counsel

  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)

  :bind
  ([remap describe-key] . helpful-key))


(provide 'bahnhof-helpful)
;;; bahnhof-helpful.el ends here
