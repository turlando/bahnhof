(deftheme arc-dark)

(setq arc-dark-color-bg "#2F343F")

;; (custom-theme-set-faces
;;  'arc-dark
;;  '(default ((t (:slant   normal
;;                 :weight  normal
;;                 :height  98
;;                 :width   normal
;;                 :foundry "ADBO"
;;                 :family  "Source Code Pro")))))

(custom-theme-set-faces
 'arc-dark
 `(default ((t (:background ,arc-dark-color-bg)))))

(provide-theme 'arc-dark)
