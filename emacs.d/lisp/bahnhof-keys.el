;;; bahnhof-keys.el                                   -*- lexical-binding: t -*-

(defconst bahnhof-leader-key "SPC")
(defconst bahnhof-buffer-key "b")

(use-package general
  :demand

  :config
  (general-create-definer bahnhof-leader-def
    :states '(emacs normal motion insert visual hybrid operator)
    :prefix bahnhof-leader-key
    :keymaps 'override)

  (general-create-definer bahnhof-buffer-def
    :wrapping bahnhof-leader-def
    :infix bahnhof-buffer-key
    :wk-full-keys nil
    "" '(:ignore t :which-key "buffer"))

  (bahnhof-leader-def
   "SPC" '(counsel-M-x :which-key "M-x"))

  (bahnhof-buffer-def
   "b" 'counsel-switch-buffer
   "n" 'next-buffer
   "p" 'previous-buffer
   "k" 'kill-buffer
   "d" 'kill-buffer-and-window))


(provide 'bahnhof-keys)
;;; bahnhof-keys.el ends here
