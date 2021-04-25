;;; bahnhof-packaging.el                              -*- lexical-binding: t -*-

;;; Package sources

(setq package-archives '(("elpa" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))


;;; Initialize package manager

(require 'package)

(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))


;;; Initialize use-package

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)

(setq use-package-always-ensure t)


(provide 'bahnhof-packaging)
;;; bahnhof-packaging.el ends here
