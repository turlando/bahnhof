;;; bahnhof-ivy.el                                    -*- lexical-binding: t -*-

(use-package ivy
  :demand

  :bind (:map ivy-minibuffer-map
         ("C-l" . ivy-alt-done)
         ("C-h" . ivy-backward-delete-char)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)

         :map ivy-switch-buffer-map
         ("C-l" . ivy-alt-done)
         ("C-k" . ivy-previous-line) ; otherwise C-k will kill the buffer
         ("C-d" . ivy-switch-buffer-kill))

  :config (ivy-mode 1))

(use-package counsel
  :demand

  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file))

  :config (setq ivy-initial-inputs-alist nil)) ;; Don't search starting with ^


(provide 'bahnhof-ivy)
;;; bahnhof-ivy.el ends here
