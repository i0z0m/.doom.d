(setq doom-font (font-spec :family "Input Mono" :size 16)
            doom-big-font (font-spec :family "Input Mono" :size 20))
(defun zyro/monitor-width-profile-setup ()
  "Calcuate or determine width of display by Dividing height BY width and then setup window configuration to adapt to monitor setup"
  (let ((size (* (/ (float (display-pixel-height)) (float (display-pixel-width))) 10)))
    (when (= size 2.734375)
      (set-popup-rule! "^\\*lsp-help" :side 'left :size .40 :select t)
      (set-popup-rule! "*helm*" :side 'left :size .30 :select t)
      (set-popup-rule! "*Capture*" :side 'left :size .30 :select t)
      (set-popup-rule! "*CAPTURE-*" :side 'left :size .30 :select t)
      (set-popup-rule! "*Org Agenda*" :side 'left :size .25 :select t))))

(defun zyro/monitor-size-profile-setup ()
  "Calcuate our monitor size and then configure element sizes accordingly"
  (let ((size (/ (* (float (display-pixel-width)) (float (display-pixel-height))) 100)))
    (when (>= size 71600.0)
      (setq doom-font (font-spec :family "Input Mono" :size 16)
            doom-big-font (font-spec :family "Input Mono" :size 20)))
    (when (>= size 49536.0)
      (setq doom-font (font-spec :family "Input Mono" :size 18)
            doom-big-font (font-spec :family "Input Mono" :size 22)))
    (when (>= size 39936.0)
      (setq doom-font (font-spec :family "Input Mono" :size 16)
            doom-big-font (font-spec :family "Input Mono" :size 20)))))

(after! org (setq org-hide-emphasis-markers t
                  org-hide-leading-stars t
                  org-list-demote-modify-bullet '(("+" . "-") ("1." . "a.") ("-" . "+"))))
(setq org-superstar-headline-bullets-list '("●" "○"))
(setq org-ellipsis "▼")
(setq org-superstar-item-bullet-alist nil)

(load! "gtd.el")
(use-package org-gtd
  :defer
  :config
  (setq org-gtd-folder '"~/.org/gtd/")
  (setq org-projects-folder '"~/.org/gtd/projects/")
  (setq org-gtd-task-files '("next.org" "personal.org" "work.org" "coding.org" "evil-plans.org"))
  (setq org-gtd-refile-properties '("CATEGORY")))

(defun zyro/rifle-roam ()
  "Rifle through your ROAM directory"
  (interactive)
  (helm-org-rifle-directories org-roam-directory))

(map! :after org
      :map org-mode-map
      :leader
      :prefix ("n" . "notes")
      :desc "Rifle ROAM Notes" "!" #'zyro/rifle-roam)

(after! org (setq org-agenda-diary-file "~/.org/diary.org"
                  org-agenda-dim-blocked-tasks t
                  org-agenda-use-time-grid t
                  org-agenda-hide-tags-regexp "\\w+"
                  org-agenda-compact-blocks nil
                  org-agenda-block-separator 61
                  org-agenda-skip-scheduled-if-done t
                  org-agenda-skip-deadline-if-done t
                  org-enforce-todo-checkbox-dependencies t
                  org-enforce-todo-dependencies t
                  org-habit-show-habits t))

(setq org-agenda-files (append (file-expand-wildcards (concat org-gtd-folder "*.org"))))

(setq org-capture-templates
      '(("n" "Daily notes" plain (file zyro/capture-daily-notes)
         (file "~/.doom.d/templates/roam-notes.org"))
        ("B" "Bookmark" entry (file (expand-file-name "bookmarks.org" "~/org/"))
         "* %^{Something}")
        ("c" "Capture" plain (file "~/.org/gtd/inbox.org")
         (file "~/.doom.d/templates/capture.org"))
        ("a" "Article" plain (file+headline (concat (doom-project-root) "articles.org") "Inbox")
         "%(call-interactively #'org-cliplink-capture)")
        ("x" "Time Tracker" entry (file+headline "~/.org/timetracking.org" "Time Tracker")
         (file "~/.doom.d/templates/timetracker.org") :clock-in t :clock-resume t)))

(after! org (setq org-image-actual-width nil
                  org-archive-location "archives.org::datetree"
                  projectile-project-search-path '("~/projectile/")))

(after! org (setq org-html-head-include-scripts t
                  org-export-with-toc t
                  org-export-with-author t
                  org-export-headline-levels 4
                  org-export-with-drawers nil
                  org-export-with-email t
                  org-export-with-footnotes t
                  org-export-with-sub-superscripts nil
                  org-export-with-latex t
                  org-export-with-section-numbers nil
                  org-export-with-properties nil
                  org-export-with-smart-quotes t
                  org-export-backends '(pdf ascii html latex odt md pandoc)))

(require 'org-id)
(setq org-link-file-path-type 'relative)

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "STRT(s)" "HOLD(h)" "|" "DONE(d)" "KILL(k)")))

(after! org (setq org-log-state-notes-insert-after-drawers nil
                  org-log-into-drawer t
                  org-log-done 'time
                  org-log-repeat 'time
                  org-log-redeadline 'note
                  org-log-reschedule 'note))

(setq org-use-property-inheritance t ; We like to inhert properties from their parents
      org-catch-invisible-edits 'error) ; Catch invisible edits

(after! org (setq org-publish-project-alist
                  '(("attachments"
                     :base-directory "~/.org/"
                     :recursive t
                     :base-extension "jpg\\|jpeg\\|png\\|pdf\\|css"
                     :publishing-directory "~/publish_html"
                     :publishing-function org-publish-attachment)
                    ("notes-to-orgfiles"
                     :base-directory "~/.org/notes/"
                     :publishing-directory "~/notes/"
                     :base-extension "org"
                     :recursive t
                     :publishing-function org-org-publish-to-org)
                    ("notes"
                     :base-directory "~/.org/notes/elisp/"
                     :publishing-directory "~/publish_html"
                     :section-numbers nil
                     :base-extension "org"
                     :with-properties nil
                     :with-drawers (not "LOGBOOK")
                     :with-timestamps active
                     :recursive t
                     :auto-sitemap t
                     :sitemap-filename "sitemap.html"
                     :publishing-function org-html-publish-to-html
                     :html-head "<link rel=\"stylesheet\" href=\"http://dakrone.github.io/org.css\" type=\"text/css\"/>"
;                     :html-head "<link rel=\"stylesheet\" href=\"https://codepen.io/nmartin84/pen/RwPzMPe.css\" type=\"text/css\"/>"
;                     :html-head-extra "<style type=text/css>body{ max-width:80%;  }</style>"
                     :html-link-up "../"
                     :with-email t
                     :html-link-up "../../index.html"
                     :auto-preamble t
                     :with-toc t)
                    ("myprojectweb" :components("attachments" "notes" "notes-to-orgfiles")))))

(after! org (setq org-refile-targets '((nil :maxlevel . 9)
                                       (org-agenda-files :maxlevel . 4))
                  org-refile-use-outline-path 'buffer-name
                  org-outline-path-complete-in-steps nil
                  org-refile-allow-creating-parent-nodes 'confirm))

(after! org (setq org-startup-indented 'indent
                  org-startup-folded 'content
                  org-src-tab-acts-natively t))
(add-hook 'org-mode-hook 'org-indent-mode)
(add-hook 'org-mode-hook 'turn-off-auto-fill)

(require 'org-roam-protocol)
(setq org-protocol-default-template-key "d")

(setq org-clock-continuously t)

(setq org-tags-column 0)
(setq org-tag-alist '((:startgrouptag)
                      ("Context")
                      (:grouptags)
                      ("@home" . ?h)
                      ("@computer")
                      ("@work")
                      ("@place")
                      ("@bills")
                      ("@order")
                      ("@labor")
                      ("@read")
                      ("@brainstorm")
                      ("@planning")
                      (:endgrouptag)
                      (:startgrouptag)
                      ("Categories")
                      (:grouptags)
                      ("vehicles")
                      ("health")
                      ("house")
                      ("hobby")
                      ("coding")
                      ("material")
                      ("goal")
                      (:endgrouptag)
                      (:startgrouptag)
                      ("Section")
                      (:grouptags)
                      ("#coding")
                      ("#research")))

(setq user-full-name "Nick Martin"
      user-mail-address "nmartin84@gmail.com")

(setq diary-file "~/.org/diary.org")

(display-time-mode 1)
(setq display-time-day-and-date t)

(bind-key "<f6>" #'link-hint-copy-link)
(bind-key "C-M-<up>" #'evil-window-up)
(bind-key "C-M-<down>" #'evil-window-down)
(bind-key "C-M-<left>" #'evil-window-left)
(bind-key "C-M-<right>" #'evil-window-right)
(map! :after org
      :map org-mode-map
      :leader
      :desc "Move up window" "<up>" #'evil-window-up
      :desc "Move down window" "<down>" #'evil-window-down
      :desc "Move left window" "<left>" #'evil-window-left
      :desc "Move right window" "<right>" #'evil-window-right
      :desc "Toggle Narrowing" "!" #'org-toggle-narrow-to-subtree
      :desc "Find and Narrow" "^" #'+org-find-headline-narrow
      :desc "Rifle Project Files" "P" #'helm-org-rifle-project-files
      :prefix ("s" . "+search")
      :desc "Counsel Narrow" "n" #'counsel-narrow
      :desc "Ripgrep Directory" "d" #'counsel-rg
      :desc "Rifle Buffer" "b" #'helm-org-rifle-current-buffer
      :desc "Rifle Agenda Files" "a" #'helm-org-rifle-agenda-files
      :desc "Rifle Project Files" "#" #'helm-org-rifle-project-files
      :desc "Rifle Other Project(s)" "$" #'helm-org-rifle-other-files
      :prefix ("l" . "+links")
      "o" #'org-open-at-point
      "g" #'eos/org-add-ids-to-headlines-in-file)

(map! :leader
      :desc "Set Bookmark" "`" #'my/goto-bookmark-location
      :prefix ("s" . "search")
      :desc "Deadgrep Directory" "d" #'deadgrep
      :desc "Swiper All" "@" #'swiper-all
      :prefix ("o" . "open")
      :desc "Elfeed" "e" #'elfeed
      :desc "Deft" "w" #'deft
      :desc "Next Tasks" "n" #'org-find-next-tasks-file)

(when (equal (window-system) nil)
  (and
   (bind-key "C-<down>" #'+org/insert-item-below)
   (setq doom-theme 'doom-monokai-pro)
   (setq doom-font (font-spec :family "Input Mono" :size 20))))

(global-auto-revert-mode 1)
(setq undo-limit 80000000
      evil-want-fine-undo t
;      auto-save-default t
      inhibit-compacting-font-caches t)
(whitespace-mode -1)

(defun zyro/remove-lines ()
  "Remove lines mode."
  (display-line-numbers-mode -1))
(remove-hook! '(org-roam-mode-hook) #'zyro/remove-lines)

(setq display-line-numbers-type t)
(setq-default
 delete-by-moving-to-trash t
 tab-width 4
 uniquify-buffer-name-style 'forward
 window-combination-resize t
 x-stretch-cursor t)

(after! org
  (set-company-backend! 'org-mode 'company-capf '(company-yasnippet company-org-roam))
  (setq company-idle-delay 0.25))

(use-package define-word
  :config
  (map! :after org
        :map org-mode-map
        :leader
        :desc "Define word at point" "@" #'define-word-at-point))

;(use-package org-pdftools
;  :hook (org-load . org-pdftools-setup-link))

(after! org (setq org-ditaa-jar-path "~/.emacs.d/.local/straight/repos/org-mode/contrib/scripts/ditaa.jar"))

(use-package gnuplot
  :defer
  :config
  (setq gnuplot-program "gnuplot"))

; MERMAID
(use-package mermaid-mode
  :defer
  :config
  (setq mermaid-mmdc-location "/node_modules/.bin/mmdc"
        ob-mermaid-cli-path "/node-modules/.bin/mmdc"))

; PLANTUML
(use-package ob-plantuml
  :ensure nil
  :commands
  (org-babel-execute:plantuml)
  :defer
  :config
  (setq plantuml-jar-path (expand-file-name "~/.doom.d/plantuml.jar")))

(use-package elfeed-org
  :defer
  :config
  (setq rmh-elfeed-org-files (list "~/.elfeed/elfeed.org")))
(use-package elfeed
  :defer
  :config
  (setq elfeed-db-directory "~/.elfeed/"))

;; (require 'elfeed-org)
;; (elfeed-org)
;; (setq elfeed-db-directory "~/.elfeed/")
;; (setq rmh-elfeed-org-files (list "~/.elfeed/elfeed.org"))

(load! "my-deft-title.el")
(use-package deft
  :bind (("<f8>" . deft))
  :commands (deft deft-open-file deft-new-file-named)
  :config
  (setq deft-directory "~/.org/"
        deft-auto-save-interval 0
        deft-recursive t
        deft-current-sort-method 'title
        deft-extensions '("md" "txt" "org")
        deft-use-filter-string-for-filename t
        deft-use-filename-as-title nil
        deft-markdown-mode-title-level 1
        deft-file-naming-rules '((nospace . "-"))))
(require 'my-deft-title)
(advice-add 'deft-parse-title :around #'my-deft/parse-title-with-directory-prepended)

(use-package helm-org-rifle
  :after (helm org)
  :preface
  (autoload 'helm-org-rifle-wiki "helm-org-rifle")
  :config
  (add-to-list 'helm-org-rifle-actions '("Insert link" . helm-org-rifle--insert-link) t)
  (add-to-list 'helm-org-rifle-actions '("Store link" . helm-org-rifle--store-link) t)
  (defun helm-org-rifle--store-link (candidate &optional use-custom-id)
    "Store a link to CANDIDATE."
    (-let (((buffer . pos) candidate))
      (with-current-buffer buffer
        (org-with-wide-buffer
         (goto-char pos)
         (when (and use-custom-id
                    (not (org-entry-get nil "CUSTOM_ID")))
           (org-set-property "CUSTOM_ID"
                             (read-string (format "Set CUSTOM_ID for %s: "
                                                  (substring-no-properties
                                                   (org-format-outline-path
                                                    (org-get-outline-path t nil))))
                                          (helm-org-rifle--make-default-custom-id
                                           (nth 4 (org-heading-components))))))
         (call-interactively 'org-store-link)))))

  ;; (defun helm-org-rifle--narrow (candidate)
  ;;   "Go-to and then Narrow Selection"
  ;;   (helm-org-rifle-show-entry candidate)
  ;;   (org-narrow-to-subtree))

  (defun helm-org-rifle--store-link-with-custom-id (candidate)
    "Store a link to CANDIDATE with a custom ID.."
    (helm-org-rifle--store-link candidate 'use-custom-id))

  (defun helm-org-rifle--insert-link (candidate &optional use-custom-id)
    "Insert a link to CANDIDATE."
    (unless (derived-mode-p 'org-mode)
      (user-error "Cannot insert a link into a non-org-mode"))
    (let ((orig-marker (point-marker)))
      (helm-org-rifle--store-link candidate use-custom-id)
      (-let (((dest label) (pop org-stored-links)))
        (org-goto-marker-or-bmk orig-marker)
        (org-insert-link nil dest label)
        (message "Inserted a link to %s" dest))))

  (defun helm-org-rifle--make-default-custom-id (title)
    (downcase (replace-regexp-in-string "[[:space:]]" "-" title)))

  (defun helm-org-rifle--insert-link-with-custom-id (candidate)
    "Insert a link to CANDIDATE with a custom ID."
    (helm-org-rifle--insert-link candidate t))

  (helm-org-rifle-define-command
   "wiki" ()
   "Search in \"~/lib/notes/writing\" and `plain-org-wiki-directory' or create a new wiki entry"
   :sources `(,(helm-build-sync-source "Exact wiki entry"
                 :candidates (plain-org-wiki-files)
                 :action #'plain-org-wiki-find-file)
              ,@(--map (helm-org-rifle-get-source-for-file it) files)
              ,(helm-build-dummy-source "Wiki entry"
                 :action #'plain-org-wiki-find-file))
   :let ((files (let ((directories (list "~/lib/notes/writing"
                                         plain-org-wiki-directory
                                         "~/lib/notes")))
                  (-flatten (--map (f-files it
                                            (lambda (file)
                                              (s-matches? helm-org-rifle-directories-filename-regexp
                                                          (f-filename file))))
                                   directories))))
         (helm-candidate-separator " ")
         (helm-cleanup-hook (lambda ()
                              ;; Close new buffers if enabled
                              (when helm-org-rifle-close-unopened-file-buffers
                                (if (= 0 helm-exit-status)
                                    ;; Candidate selected; close other new buffers
                                    (let ((candidate-source (helm-attr 'name (helm-get-current-source))))
                                      (dolist (source helm-sources)
                                        (unless (or (equal (helm-attr 'name source)
                                                           candidate-source)
                                                    (not (helm-attr 'new-buffer source)))
                                          (kill-buffer (helm-attr 'buffer source)))))
                                  ;; No candidates; close all new buffers
                                  (dolist (source helm-sources)
                                    (when (helm-attr 'new-buffer source)
                                      (kill-buffer (helm-attr 'buffer source))))))))))
  :general
  (:keymaps 'org-mode-map
   "M-s r" #'helm-org-rifle-current-buffer)
  :custom
  (helm-org-rifle-directories-recursive t)
  (helm-org-rifle-show-path t)
  (helm-org-rifle-test-against-path t))

(provide 'setup-helm-org-rifle)

(setq org-roam-directory "~/.org/")
(setq org-roam-tag-sources '(prop all-directories))
(setq org-roam-db-location "~/.org/roam.db")
(add-to-list 'safe-local-variable-values
'(org-roam-directory . "."))

(use-package org-roam-server
  :ensure t
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8070
        org-roam-server-export-inline-images t
        org-roam-server-authenticate nil
        org-roam-server-network-poll nil
        org-roam-server-network-arrows 'from
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20))

(defun my/org-roam--backlinks-list-with-content (file)
  (with-temp-buffer
    (if-let* ((backlinks (org-roam--get-backlinks file))
              (grouped-backlinks (--group-by (nth 0 it) backlinks)))
        (progn
          (insert (format "\n\n* %d Backlinks\n"
                          (length backlinks)))
          (dolist (group grouped-backlinks)
            (let ((file-from (car group))
                  (bls (cdr group)))
              (insert (format "** [[file:%s][%s]]\n"
                              file-from
                              (org-roam--get-title-or-slug file-from)))
              (dolist (backlink bls)
                (pcase-let ((`(,file-from _ ,props) backlink))
                  (insert (s-trim (s-replace "\n" " " (plist-get props :content))))
                  (insert "\n\n")))))))
    (buffer-string)))

  (defun my/org-export-preprocessor (backend)
    (let ((links (my/org-roam--backlinks-list-with-content (buffer-file-name))))
      (unless (string= links "")
        (save-excursion
          (goto-char (point-max))
          (insert (concat "\n* Backlinks\n") links)))))

  (add-hook 'org-export-before-processing-hook 'my/org-export-preprocessor)

(require 'ox-reveal)
(setq org-reveal-root "https://cdn.jsdelivr.net/npm/reveal.js")
(setq org-reveal-title-slide nil)

(org-super-agenda-mode t)

(setq org-agenda-custom-commands
      '(("w" "Master Agenda"
         ((agenda ""
                  ((org-agenda-overriding-header "Master Agenda")
                   (org-agenda-files (append (file-expand-wildcards "~/.org/tasks/*.org")))
                   (org-agenda-time-grid nil)
                   (org-agenda-start-day (org-today))
                   (org-agenda-span '1)))
          (todo ""
                ((org-agenda-overriding-header "Master TODO List")
                 (org-agenda-files (append (file-expand-wildcards "~/.org/tasks/*")))
                 (org-super-agenda-groups
                  '((:auto-category t)))))
          (todo ""
                ((org-agenda-files (list "~/.doom.d/config.org"))
                 (org-super-agenda-groups
                  '((:auto-parent t)))))))
        ("i" "Inbox"
         ((todo ""
                ((org-agenda-overriding-header "")
                 (org-agenda-files (list "~/.org/inbox.org"))
                 (org-super-agenda-groups
                  '((:category "Cases")
                    (:category "Emails")
                    (:category "Inbox")))))))
        ("x" "Someday"
         ((todo ""
                ((org-agenda-overriding-header "Someday")
                 (org-agenda-files (list "~/.org/someday.org"))
                 (org-super-agenda-groups
                  '((:auto-parent t)))))))))

(let ((secrets (expand-file-name "secrets.el" doom-private-dir)))
(when (file-exists-p secrets)
  (load secrets)))

(after! org (zyro/monitor-width-profile-setup)
  (zyro/monitor-size-profile-setup)
  (toggle-frame-fullscreen)
  (setq doom-theme 'doom-snazzy))
