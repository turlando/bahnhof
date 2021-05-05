;;; bahnhof-functions.el                              -*- lexical-binding: t -*-

; taken from spacemacs. TODO: refactor
(defun bahnhof-delete-current-buffer-file ()
  "Removes file connected to current buffer and kills buffer."
  (interactive)
  (let ((filename (buffer-file-name))
        (buffer (current-buffer))
        (name (buffer-name)))
    (if (not (and filename (file-exists-p filename)))
        ;(ido-kill-buffer)
        (kill-buffer)
      (if (yes-or-no-p
           (format "Are you sure you want to delete this file: '%s'?" name))
          (progn
            (delete-file filename t)
            (kill-buffer buffer)
            ;(when (and (configuration-layer/package-used-p 'projectile)
            ;           (projectile-project-p))
            ;  (call-interactively #'projectile-invalidate-cache))
            (message "File deleted: '%s'" filename))
        (message "Canceled: File deletion")))))

; taken from spacemacs. TODO: refactor
(defun bahnhof-rename-buffer-visiting-a-file (&optional arg)
  (let* ((old-short-name (buffer-name))
         (old-filename (buffer-file-name))
         (old-dir (file-name-directory old-filename))
         (new-name (read-file-name "New name: " (if arg old-dir old-filename)))
         (new-dir (file-name-directory new-name))
         (new-short-name (file-name-nondirectory new-name))
         (file-moved-p (not (string-equal new-dir old-dir)))
         (file-renamed-p (not (string-equal new-short-name old-short-name))))
    (cond ((get-buffer new-name)
           (error "A buffer named '%s' already exists!" new-name))
          ((string-equal new-name old-filename)
           ;(spacemacs/show-hide-helm-or-ivy-prompt-msg
           (message
            "Rename failed! Same new and old name" 1.5)
           (bahnhof-rename-current-buffer-file))
          (t
           (let ((old-directory (file-name-directory new-name)))
             (when (and (not (file-exists-p old-directory))
                        (yes-or-no-p
                         (format "Create directory '%s'?" old-directory)))
               (make-directory old-directory t)))
           (rename-file old-filename new-name 1)
           (rename-buffer new-name)
           (set-visited-file-name new-name)
           (set-buffer-modified-p nil)
           (when (fboundp 'recentf-add-file)
             (recentf-add-file new-name)
             (recentf-remove-if-non-kept old-filename))
           ;(when (and (configuration-layer/package-used-p 'projectile)
           ;           (projectile-project-p))
           ;  (call-interactively #'projectile-invalidate-cache))
           (message (cond ((and file-moved-p file-renamed-p)
                           (concat "File Moved & Renamed\n"
                                   "From: " old-filename "\n"
                                   "To:   " new-name))
                          (file-moved-p
                           (concat "File Moved\n"
                                   "From: " old-filename "\n"
                                   "To:   " new-name))
                          (file-renamed-p
                           (concat "File Renamed\n"
                                   "From: " old-short-name "\n"
                                   "To:   " new-short-name))))))))

; taken from spacemacs. TODO: refactor
(defun bahnhof-rename-buffer-or-save-new-file ()
  (let ((old-short-name (buffer-name))
        key)
    (while (not (memq key '(?s ?r)))
      (setq key (read-key (propertize
                           (format
                            (concat "Buffer '%s' is not visiting a file: "
                                    "[s]ave to file or [r]ename buffer?")
                            old-short-name)
                           'face 'minibuffer-prompt)))
      (cond ((eq key ?s)            ; save to file
             ;; this allows for saving a new empty (unmodified) buffer
             (unless (buffer-modified-p) (set-buffer-modified-p t))
             (save-buffer))
            ((eq key ?r)            ; rename buffer
             (let ((new-buffer-name (read-string "New buffer name: ")))
               (while (get-buffer new-buffer-name)
                 ;; ask to rename again, if the new buffer name exists
                 (if (yes-or-no-p
                      (format (concat "A buffer named '%s' already exists: "
                                      "Rename again?")
                              new-buffer-name))
                     (setq new-buffer-name (read-string "New buffer name: "))
                   (keyboard-quit)))
               (rename-buffer new-buffer-name)
               (message (concat "Buffer Renamed\n"
                                "From: " old-short-name "\n"
                                "To:   " new-buffer-name))))
            ;; ?\a = C-g, ?\e = Esc and C-[
            ((memq key '(?\a ?\e)) (keyboard-quit))))))

; taken from spacemacs. TODO: refactor
(defun bahnhof-rename-current-buffer-file (&optional arg)
  "Rename the current buffer and the file it is visiting.
If the buffer isn't visiting a file, ask if it should
be saved to a file, or just renamed.

If called without a prefix argument, the prompt is
initialized with the current directory instead of filename."
  (interactive "P")
  (let ((file (buffer-file-name)))
    (if (and file (file-exists-p file))
        (bahnhof-rename-buffer-visiting-a-file arg)
      (bahnhof-rename-buffer-or-save-new-file))))


(provide 'bahnhof-functions)
;;; bahnhof-functions.el ends here
