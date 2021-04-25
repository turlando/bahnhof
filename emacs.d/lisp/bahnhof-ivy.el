;;; bahnhof-ivy.el                                    -*- lexical-binding: t -*-

(use-package ivy
  :demand  ; otherwise find-file and similar will not work
  :diminish

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


(provide 'bahnhof-ivy)
;;; bahnhof-ivy.el ends here
