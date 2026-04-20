;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;;(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-
;; Theme: match Ghostty/tmux Tokyo Night colors.
(setq doom-theme 'doom-tokyo-night)

;; Relative numbers match the Neovim setup and make count motions easier.
(setq display-line-numbers-type 'relative
      confirm-kill-emacs nil)

(setq-default tab-width 4
              standard-indent 4
              indent-tabs-mode nil)

;; Fast insert-mode escape, same as Neovim jk/kj.
(setq evil-escape-key-sequence "jk"
      evil-escape-unordered-key-sequence t
      evil-escape-delay 0.25)

(defun my/evil-jump-up-7 ()
  "Move up 7 lines."
  (interactive)
  (evil-previous-line 7))

(defun my/evil-jump-left-7 ()
  "Move left 7 characters."
  (interactive)
  (evil-backward-char 7))

(defun my/evil-jump-down-7 ()
  "Move down 7 lines."
  (interactive)
  (evil-next-line 7))

(defun my/evil-jump-right-7 ()
  "Move right 7 characters."
  (interactive)
  (evil-forward-char 7))

(defun my/evil-search-next-centered ()
  "Jump to the next search result and recenter."
  (interactive)
  (evil-ex-search-next)
  (recenter))

(defun my/evil-search-previous-centered ()
  "Jump to the previous search result and recenter."
  (interactive)
  (evil-ex-search-previous)
  (recenter))

(defun my/split-window-above ()
  "Split the current window above and focus it."
  (interactive)
  (split-window (selected-window) nil 'above)
  (windmove-up))

(defun my/split-window-left ()
  "Split the current window to the left and focus it."
  (interactive)
  (split-window (selected-window) nil 'left)
  (windmove-left))

(defun my/split-window-below ()
  "Split the current window below and focus it."
  (interactive)
  (split-window-below)
  (windmove-down))

(defun my/split-window-right ()
  "Split the current window to the right and focus it."
  (interactive)
  (split-window-right)
  (windmove-right))

(defun my/enlarge-window-5 ()
  "Increase window height by 5 lines."
  (interactive)
  (enlarge-window 5))

(defun my/shrink-window-horizontally-5 ()
  "Decrease window width by 5 columns."
  (interactive)
  (shrink-window-horizontally 5))

(defun my/shrink-window-5 ()
  "Decrease window height by 5 lines."
  (interactive)
  (shrink-window 5))

(defun my/enlarge-window-horizontally-5 ()
  "Increase window width by 5 columns."
  (interactive)
  (enlarge-window-horizontally 5))

(defun my/duplicate-line-or-region ()
  "Duplicate current line, or active region if any."
  (interactive)
  (let ((orig-point (point)))
    (if (use-region-p)
        (let* ((beg (region-beginning))
               (end (region-end))
               (text (buffer-substring beg end)))
          (goto-char end)
          (insert text)
          (goto-char (+ orig-point (- end beg))))
      (let* ((beg (line-beginning-position))
             (end (line-end-position))
             (text (buffer-substring beg end))
             (col (current-column)))
        (end-of-line)
        (newline)
        (insert text)
        (move-to-column col)))))

(after! evil
  (define-key evil-normal-state-map (kbd "C-w") window-prefix-map)
  (define-key evil-motion-state-map (kbd "C-w") window-prefix-map)
  (define-key window-prefix-map (kbd "i") #'windmove-up)
  (define-key window-prefix-map (kbd "j") #'windmove-left)
  (define-key window-prefix-map (kbd "k") #'windmove-down)
  (define-key window-prefix-map (kbd "l") #'windmove-right)
  (define-key window-prefix-map (kbd "c") #'delete-window)
  (define-key window-prefix-map (kbd "o") #'delete-other-windows)

  (map! :nv "i" #'evil-previous-line
        :nv "j" #'evil-backward-char
        :nv "k" #'evil-next-line
        :nv "l" #'evil-forward-char

        :nv "I" #'my/evil-jump-up-7
        :nv "J" #'my/evil-jump-left-7
        :nv "K" #'my/evil-jump-down-7
        :nv "L" #'my/evil-jump-right-7

        :n "s" #'evil-insert-state
        :nv "n" #'evil-beginning-of-line
        :nv "m" #'evil-end-of-line
        :nv "t" #'evil-jump-item
        :n "=" #'my/evil-search-next-centered
        :n "-" #'my/evil-search-previous-centered
        :n "U" #'evil-redo
        :n "S" #'evil-write
        :n "Q" #'evil-quit
        :ni "C-r" #'quickrun
        :nvi "C-c d" #'my/duplicate-line-or-region))

(map! :leader
      :desc "Clear search highlights"
      "RET" #'evil-ex-nohighlight

      (:prefix ("w" . "window")
       :desc "Split window above" "i" #'my/split-window-above
       :desc "Split window left"  "j" #'my/split-window-left
       :desc "Split window below" "k" #'my/split-window-below
       :desc "Split window right" "l" #'my/split-window-right)

      (:prefix ("r" . "resize")
       :desc "Increase window height" "i" #'my/enlarge-window-5
       :desc "Decrease window width"  "j" #'my/shrink-window-horizontally-5
       :desc "Decrease window height" "k" #'my/shrink-window-5
       :desc "Increase window width"  "l" #'my/enlarge-window-horizontally-5))
