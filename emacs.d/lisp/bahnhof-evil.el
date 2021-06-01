;;; bahnhof-evil.el                                   -*- lexical-binding: t -*-

(use-package undo-fu)

(use-package evil
  :demand

  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-fu)

  :config
  (evil-mode 1))


(provide 'bahnhof-evil)
;;; bahnhof-evil.el ends here
