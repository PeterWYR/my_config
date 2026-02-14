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
;; 主题：Dracula
(setq doom-theme 'doom-dracula)

;; 行号：使用相对行号 (方便配合 10j, 5k 这种操作)
(setq display-line-numbers-type 'relative)

(setq confirm-kill-emacs nil)
;; =========================================
;; 1. 核心移动：IJKL (Peter 的定制方案)
;; =========================================

;; 基础移动
(map! :nv "i" #'evil-previous-line   ; 上
      :nv "k" #'evil-next-line       ; 下
      :nv "j" #'evil-backward-char   ; 左
      :nv "l" #'evil-forward-char)   ; 右

;; 极速大跳 (Shift + IJKL)
(map! :nv "I" (cmd! (evil-previous-line 10))
      :nv "K" (cmd! (evil-next-line 10))
      :nv "J" (cmd! (evil-backward-char 10))
      :nv "L" (cmd! (evil-forward-char 10)))

;; =========================================
;; 2. 行首行尾 (修改版)
;; =========================================

(after! evil
  ;; n -> first non-blank char (like Vim ^)
  (map! :n "n" #'evil-first-non-blank
        :v "n" #'evil-first-non-blank)

  ;; m -> end of line (like Vim $)
  (map! :n "m" #'evil-end-of-line
        :v "m" #'evil-end-of-line))

;; [重要] 恢复 n 的原厂功能 (查找下一个)
;; 这一步至关重要，它保证了后面的 = 和 - 能正常工作
(map! :n "=" #'evil-search-next)
(map! :n "-" #'evil-search-previous)
(after! evil
  ;; 让 = / - 复用 / ? 的高亮搜索结果
  (map! :map (evil-normal-state-map evil-motion-state-map)
        "=" #'evil-ex-search-next
        "-" #'evil-ex-search-previous))

;; =========================================
;; 3. 搜索跳转 (=/-) 与 插入模式 (s)
;; =========================================

;; s -> 插入模式
(map! :n "s" #'evil-insert-state)
(map! :leader
      :desc "清除搜索高亮"
      "RET" #'evil-ex-nohighlight)



;; =========================================
;; 4. 其他功能 (U 重做, C-r 运行)
;; =========================================
(map! :n "U" #'evil-redo)
(map! :ni "C-r" #'quickrun) ; 记得在 packages.el 里装了 (package! quickrun)


;; =========================================
;; 5. 极速 Escape：jk / kj
;; =========================================
;; 设置这两个变量后，在插入模式连按 jk 或 kj 都会瞬间退回到 Normal 模式
(setq evil-escape-key-sequence "jk")        ; 设定主要序列
(setq evil-escape-unordered-key-sequence t) ; 开启无序匹配 (让 kj 也生效)
(setq evil-escape-delay 0.25)               ; 判定时间 0.25秒，如果误触太频繁可调低到 0.15
;; Default: indent width = 4


(setq-default tab-width 4)
(setq-default standard-indent 4)

;; Use spaces instead of literal TAB characters (recommended)
(setq-default indent-tabs-mode nil)
(after! evil
  (map! :n "S" #'evil-write
        :n "Q" #'evil-quit))


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
(map! :desc "Duplicate line/region" :nvi "C-c d" #'my/duplicate-line-or-region)

(after! evil
  (define-key evil-normal-state-map (kbd "C-w") window-prefix-map)
  (define-key evil-motion-state-map (kbd "C-w") window-prefix-map)

  (define-key window-prefix-map (kbd "i") #'windmove-up)
  (define-key window-prefix-map (kbd "j") #'windmove-left)
  (define-key window-prefix-map (kbd "k") #'windmove-down)
  (define-key window-prefix-map (kbd "l") #'windmove-right)

  (define-key window-prefix-map (kbd "s")
    (lambda () (interactive) (split-window-below) (windmove-down)))
  (define-key window-prefix-map (kbd "v")
    (lambda () (interactive) (split-window-right) (windmove-right)))

  (define-key window-prefix-map (kbd "c") #'delete-window)
  (define-key window-prefix-map (kbd "o") #'delete-other-windows))
(map! :n "H" #'evil-write
      :n "Q" #'evil-quit)
