; Japanese
;; set language as Japanese
(set-language-environment 'Japanese)
;; coding UTF8
(set-language-environment  'utf-8)
(prefer-coding-system 'utf-8)

;; fcitx.el
(fcitx-default-setup)
;; auto-off Japanese input after leaving insert mode with evil keybind
(add-hook 'evil-normal-state-entry-hook
  (lambda ()
    (if (string= "2\\n" (shell-command-to-string "${zenhan} 0"))
        (shell-command "${zenhan} 0"))))

;; emacs-mozc
(require 'mozc)
(setq default-input-method "japanese-mozc")
(setq mozc-candidate-style 'overlay)

; Allow GUI Emacs to access content from clipboard.
(setq x-select-enable-clipboard t
      x-select-enable-primary t)

; for org-agenda
;; https://stackoverflow.com/a/2010955/
(add-hook 'after-init-hook 'org-agenda-list)
;; https://christiantietze.de/posts/2019/03/sync-emacs-org-files/
;(add-hook 'auto-save-hook 'org-save-all-org-buffers)

; https://emacs.stackexchange.com/a/48584/
;; setup browser function when running in WSL
(defconst powershell-exe "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe")
(when (file-executable-p powershell-exe)
(defun my-WSL-browse-url (url &optional _new-window)
  (interactive (browse-url-interactive-arg "URL: "))
  (let ((quotedUrl (format "start '%s'" url)))
    (apply 'call-process powershell-exe
           nil 0 nil (list "-Command" quotedUrl))))
(setq-default browse-url-browser-function 'my-WSL-browse-url))
