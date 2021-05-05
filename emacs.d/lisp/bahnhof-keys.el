;;; bahnhof-keys.el                                   -*- lexical-binding: t -*-

;;; Prefix keys

(defconst bahnhof-leader-key "SPC")
(defconst bahnhof-buffer-key "b")
(defconst bahnhof-window-key "w")
(defconst bahnhof-file-key   "f")


;;; Packages

(use-package hercules
  :demand)

(use-package general
  :demand
  :requires (evil hercules))


;;; Leader prefix key

(general-create-definer bahnhof-leader-def
  :states '(emacs normal motion visual hybrid operator)
  :prefix bahnhof-leader-key
  :keymaps 'override)

(bahnhof-leader-def
 "SPC" '(counsel-M-x :which-key "M-x"))


;;; Buffer prefix key

(general-create-definer bahnhof-buffer-def
  :wrapping bahnhof-leader-def
  :infix bahnhof-buffer-key
  :wk-full-keys nil
  "" '(:ignore t :which-key "buffer"))

(general-def
  :prefix-map 'bahnhof-buffer-flip-map
  "h" '(previous-buffer :which-key "prev")
  "j" '(next-buffer     :which-key "next")
  "k" '(previous-buffer :which-key "prev")
  "l" '(next-buffer     :which-key "next"))

(hercules-def
  :toggle-funs 'bahnhof-toggle-buffer-flip-mode
  :keymap 'bahnhof-buffer-flip-map
  :transient t)

(bahnhof-buffer-def
  "b" '(counsel-switch-buffer           :which-key "switch")
  "k" '(kill-buffer                     :which-key "kill")
  "d" '(kill-buffer-and-window          :which-key "kill-close")
  "f" '(bahnhof-toggle-buffer-flip-mode :which-key "flip")
  "h" '(previous-buffer                 :which-key "prev")
  "j" '(next-buffer                     :which-key "next")
  "k" '(previous-buffer                 :which-key "prev")
  "l" '(next-buffer                     :which-key "next"))


;;; Window prefix key

(general-create-definer bahnhof-window-def
  :wrapping bahnhof-leader-def
  :infix bahnhof-window-key
  :wk-full-keys nil
  "" '(:ignore t :which-key "window"))

(general-def
  :prefix-map 'bahnhof-window-move-map
  "h" '(evil-window-left  :which-key "left")
  "j" '(evil-window-down  :which-key "down")
  "k" '(evil-window-up    :which-key "up")
  "l" '(evil-window-right :which-key "right")
  "w" '(evil-window-next  :which-key  "next"))

(hercules-def
  :toggle-funs 'bahnhof-toggle-window-move-mode
  :keymap 'bahnhof-window-move-map
  :transient t)

(general-def
  :prefix-map 'bahnhof-window-resize-map
  "h" '(shrink-window-horizontally  :which-key "shrink-h")
  "j" '(enlarge-window              :which-key "enlarge-v")
  "k" '(shrink-window               :which-key "shrink-v")
  "l" '(enlarge-window-horizontally :which-key "enlarge-h"))

(hercules-def
 :toggle-funs 'bahnhof-toggle-window-resize-mode
 :keymap 'bahnhof-window-resize-map
 :transient t)

(bahnhof-window-def
  "m" '(bahnhof-toggle-window-move-mode   :which-key "move")
  "h" '(evil-window-left                  :which-key "left")
  "j" '(evil-window-down                  :which-key "down")
  "k" '(evil-window-up                    :which-key "up")
  "l" '(evil-window-right                 :which-key "right")
  "w" '(evil-window-next                  :which-key "next")
  "v" '(split-window-vertically           :which-key "split-v")
  "b" '(split-window-horizontally         :which-key "split-h")
  "r" '(bahnhof-toggle-window-resize-mode :which-key "resize")
  "d" '(delete-window                     :which-key "close"))


;;; File prefix key

(general-create-definer bahnhof-file-def
  :wrapping bahnhof-leader-def
  :infix bahnhof-file-key
  :wk-full-keys nil
  "" '(:ignore t :which-key "file"))

(bahnhof-file-def
  "f" '(counsel-find-file                  :which-key "find")
  "s" '(save-buffer                        :which-key "save")
  "c" '(write-file                         :which-key "copy")
  "r" '(bahnhof-rename-current-buffer-file :which-key "rename")
  "d" '(bahnhof-delete-current-buffer-file :which-key "delete"))


(provide 'bahnhof-keys)
;;; bahnhof-keys.el ends here
