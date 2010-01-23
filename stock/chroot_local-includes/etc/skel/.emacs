;#####csound emacs mode#####
(require 'stef-elisp)

;#####supercollider emacs mode#####

(require 'sclang)
(require 'w3m)

;#####skeleton pair insertion for brackets and stuff#####
(global-set-key "\"" 'skeleton-pair-insert-maybe)
(global-set-key "\'" 'skeleton-pair-insert-maybe)
(global-set-key "\`" 'skeleton-pair-insert-maybe)
(global-set-key "\{" 'skeleton-pair-insert-maybe)
(global-set-key "\[" 'skeleton-pair-insert-maybe)
(global-set-key "\(" 'skeleton-pair-insert-maybe)
(global-set-key "\<" 'skeleton-pair-insert-maybe)
(setq skeleton-pair 1)

;#####no toolbar, menubar, highlight a selection while making it#####
(tool-bar-mode 0)
(scroll-bar-mode -1)
(transient-mark-mode 1)
(menu-bar-mode t)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(color-theme-selection "Oswald" nil (color-theme))
 '(emacs-goodies-el-defaults t)
 '(pop-up-frames nil)
 '(pop-up-windows t)
 '(sclang-auto-scroll-post-buffer t)
 '(sclang-eval-line-forward nil)
 '(sclang-help-path (quote ("/usr/share/SuperCollider/Help" "~/SuperCollider/Help")))
 '(sclang-library-configuration-file "~/.sclang.cfg")
 '(sclang-runtime-directory "~/SuperCollider/")
 '(sclang-server-panel "Server.default.makeGui")
 '(show-paren-mode t)
 '(w3m-pop-up-frames t)
 '(w3m-pop-up-windows nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;## hack to make the cursor work normally in w3m-mode - thanks martin :)
(eval-after-load "w3m"
 '(progn
 (define-key w3m-mode-map [left] 'backward-char)
 (define-key w3m-mode-map [right] 'forward-char)
 (define-key w3m-mode-map [up] 'previous-line)
 (define-key w3m-mode-map [down] 'next-line)
 (setq w3m-auto-show 1)
;; (setq truncate-lines 1)
;; (setq truncate-lines t)
 ))

;## make C-c copy, C-v paste etc...
(cua-mode t)
(setq cua-auto-tabify-rectangles nil) ;; Don't tabify after rectangle commands
(setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

