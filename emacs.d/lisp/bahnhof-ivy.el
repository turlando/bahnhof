;;; bahnhof-ivy.el                                    -*- lexical-binding: t -*-

(use-package ivy
  :demand
  :delight

  :bind (:map ivy-minibuffer-map
         ("C-l" . ivy-alt-done)
         ("C-h" . ivy-backward-delete-char)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         ("ESC" . minibuffer-keyboard-quit)

         :map ivy-switch-buffer-map
         ("C-l" . ivy-alt-done)
         ("C-k" . ivy-previous-line) ; otherwise C-k will kill the buffer
         ("C-d" . ivy-switch-buffer-kill))

  :config (ivy-mode 1))

(use-package counsel
  :demand

  :bind (("M-x"     . counsel-M-x)
         ("C-x b"   . counsel-switch-buffer)
         ("C-x C-f" . counsel-find-file)
         ("C-h f"   . counsel-describe-function)
         ("C-h v"   . counsel-describe-variable))

  :config (setq ivy-initial-inputs-alist nil)) ;; Don't search starting with ^

;; amx will provide history in M-x
(use-package amx)


(provide 'bahnhof-ivy)
;;; bahnhof-ivy.el ends here
