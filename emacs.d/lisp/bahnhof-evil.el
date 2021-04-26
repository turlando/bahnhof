;;; bahnhof-evil.el                                   -*- lexical-binding: t -*-

(use-package evil
  :demand

  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)

  :config
  (evil-mode 1))


(provide 'bahnhof-evil)
;;; bahnhof-evil.el ends here
