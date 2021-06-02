; デフォルトの文字コードをUTF-8Nにする
(setq *default-fileio-encoding* *encoding-utf8n*)

; クリップボードエンコーディングを自動判別
(setq *clipboard-char-encoding* *encoding-auto*)

; Windowsキーに設定
;(load-library "Gates")

; Vz風
;(require "vz-taste")

; ちょっとだけWindowsキー
(load-library "winkey")

; キーカスタマイズ
(global-set-key #\C-y 'redo)
;(global-set-key '(#\C-x #\C-p) 'print-selected-buffer-dialog)
(global-set-key '(#\C-x #\C-a) 'selection-whole-buffer)
;(global-set-key #\C-a 'selection-whole-buffer)
(global-set-key #\C-r 'replace-string)
(global-set-key #\Home 'beginning-of-virtual-line)
(global-set-key #\End 'end-of-virtual-line)
(global-set-key #\S-Home 'selection-beginning-of-virtual-line)
(global-set-key #\S-End 'selection-end-of-virtual-line)
(global-set-key #\C-Home 'beginning-of-buffer)
(global-set-key #\C-End 'end-of-buffer)
;(global-set-key #\C-F4 'close-selected-buffer)
(global-set-key #\C-w 'close-selected-buffer)
(global-set-key #\S-C-F24 'previous-buffer)       ; Shift+Ctrl+Tab
(global-set-key #\C-F24 'next-buffer)             ; Ctrl+Tab
(global-set-key #\S-F5 'call-last-kbd-macro)
(global-set-key #\S-F10 'launch-application)
(global-set-key #\F1 'local-option-property-sheet)
(global-set-key #\S-F1 'option-property-sheet)
(global-set-key #\S-F2 'change-fileio-encoding)
(global-set-key #\F3 'repeat-forward-search)      ; next search
(global-set-key #\S-F3 'repeat-backward-search)   ; back search
(global-set-key #\C-7 #'list-function)            ; list-function
(global-set-key #\C-F5 #'launch-application-dialog)

(global-set-key '(#\C-c #\b) 'start-selection-as-line)
(global-set-key '(#\C-c #\C-b) 'start-selection-as-region)
(global-set-key '(#\C-x #\C-b) 'select-buffer)
(global-set-key '(#\C-x #\g) 'grep)
(global-set-key '(#\C-x #\C-g) 'grep-dialog)
(global-set-key '(#\ESC #\r) 'previous-page)
(global-set-key '(#\ESC #\c) 'next-page)
(global-set-key '(#\ESC #\v) 'capitalize-word)

(set-extended-key-translate-table exkey-S-C-tab #\S-C-F24)
(set-extended-key-translate-table exkey-C-tab #\C-F24)

; TAGSの設定
(global-set-key #\F4 'jump-tag)                   ; jump tag
(global-set-key #\S-F4 'back-tag-jump)            ; back tag
(global-set-key #\F5 'direct-tag-jump)            ; direct-tag-jump
(global-set-key #\F7 'make-tags-file-dialog)      ; make tags

; CTAGSの設定
(load-library "ctags")
(setf *ctags-command-path* (merge-pathnames "etc/ctags.exe" (si:system-root)))
;(setf *ctags-command-option* "")
(global-set-key #\F12 'ctags-jump-tag)
(global-set-key #\C-- 'ctags-back-tag-jump)
(global-set-key #\C-= 'ctags-make-tags-file-recursive)
(global-set-key #\M-? 'ctags-select-stack)

; c-modeでタブを許可
(define-key ed::*c-mode-map* #\tab 'self-insert-command)
(define-key ed::*c++-mode-map* #\tab 'self-insert-command)

; c-modeで開くファイルを追加
(pushnew '("\\.rc" . c-mode) *auto-mode-alist* :test 'equal)
(pushnew '("\\.hrc" . c-mode) *auto-mode-alist* :test 'equal)
(pushnew '("\\.hpp" . c++-mode) *auto-mode-alist* :test 'equal)
(pushnew '("\\.hxx" . c++-mode) *auto-mode-alist* :test 'equal)

; basic-modeで開くファイルを追加
(pushnew '("\\.vbs" . basic-mode) *auto-mode-alist* :test 'equal)

; インデントの値設定
(setq c-indent-level 4)
(setq c-continued-statement-offset 4)
(setq c-argdecl-indent 4)
(setq c-brace-offset -4)
(setq c-brace-imaginary-offset 0)
(setq c-label-offset -4)
(setq c-comment-indent 0)

(setq c++-indent-level 4)
(setq c++-continued-statement-offset 4)
(setq c++-argdecl-indent 4)
(setq c++-brace-offset -4)
(setq c++-brace-imaginary-offset 0)
(setq c++-label-offset -4)
(setq c++-comment-indent 0)

; オートインデントを無効に
;(define-key ed::*c-mode-map* #\RET 'newline)
;(undefine-key ed::*c-mode-map* #\{)
;(undefine-key ed::*c-mode-map* #\{)
;(undefine-key ed::*c-mode-map* #\:)
;(undefine-key ed::*c-mode-map* #\#)
;(undefine-key ed::*c-mode-map* #\})
;(define-key ed::*c++-mode-map* #\RET 'newline)
;(undefine-key ed::*c++-mode-map* #\{)
;(undefine-key ed::*c++-mode-map* #\{)
;(undefine-key ed::*c++-mode-map* #\:)
;(undefine-key ed::*c++-mode-map* #\#)
;(undefine-key ed::*c++-mode-map* #\})

; バックスペースの効果
(global-set-key #\C-h 'delete-backward-char-or-selection)

; キーバインディング
(global-set-key #\C-/ 'undo)
(global-set-key '(#\C-x #\u) 'undo)
(global-set-key #\M-v 'previous-page)
 
; C-x C-v でファイル名ももらう (Ver.0.0.0.90 以降)
(setq *find-other-file-requires-file-name* t)

; ナイスタブ on C (and C++) モード
(setq *c-tab-always-indent* nil)
(setq *c++-tab-always-indent* nil)

; TAB だぁー！ TAB 持ってこいー！
(setq *c-indent-tabs-mode* t)
(setq *c++-indent-tabs-mode* t)

; C モードでも // を勘弁してやるか…
; by Tetsuya Kamei  [xyzzy:03700]
(set-syntax-start-c++-comment ed::*c-mode-syntax-table* #\/)
  (set-syntax-end-c++-comment ed::*c-mode-syntax-table* #\LFD)

; 対応括弧に飛ばないようにする
;;(setq *show-matched-parenthesis* nil)

; ファイラで全ファイル表示をデフォルトに
;; 2 画面用
(setq *filer-primary-file-mask* '("*"))
(setq *filer-secondary-file-mask* '("*"))
;; 1 画面用
;(setq *filer-last-file-mask* '("*"))

; タブインデント
(defun shift-selection-or-insert-tab()
  (interactive)
  (if (get-selection-type)
	  (shift-selection)
	(insert "\t")
  )
)
(defun unshift-selection-or-insert-tab()
  (interactive)
  (if (get-selection-type)
	  (unshift-selection)
  )
)
( global-set-key #\F24     'shift-selection-or-insert-tab)
( global-set-key #\S-F24   'unshift-selection-or-insert-tab)
( set-extended-key-translate-table exkey-tab #\F24)
( set-extended-key-translate-table exkey-S-tab #\S-F24)

; hlsl-mode
(require "hlsl-mode")
(load-library "hlsl-mode")
(pushnew '("\\.fx$" . hlsl-mode) *auto-mode-alist*)
(push '("\\.frag$" . hlsl-mode) *auto-mode-alist*)
(push '("\\.vert$" . hlsl-mode) *auto-mode-alist*)
(push '("\\.vfh$" . hlsl-mode) *auto-mode-alist*)
(push '("\\.cg$" . hlsl-mode) *auto-mode-alist*)

(setq *hlsl-tab-always-indent* nil) ; TABに変更
(setq *hlsl-indent-tabs-mode* t)

; XML-mode
(require "xml/xml-mode")
(use-package 'xml)
(setq *xml-indent-tabs-mode* nil); SPACEに変更
(push '("\\.lyr$" . xml-mode) *auto-mode-alist*)
(push '("\\.lyr_$" . xml-mode) *auto-mode-alist*)

; PHP-mode
(load-library "php-mode")
(pushnew '("\\.php$" . php-mode) *auto-mode-alist*)
(setq *php-tab-always-indent* nil) ; TABに変更
(setq *php-indent-tabs-mode* t)
;; php-miscを使う場合
;(load-library "php-misc")
;(setq *php-html-help-path* "H:/Program/doc/php/php_manual_ja.chm")

; py-modeの設定
(load-library "py-mode")
(push '("\\.py$" . py-mode) *auto-mode-alist*)
(push '("\\.pyw$" . py-mode) *auto-mode-alist*)

; ruby-mode
(load-library "ruby-mode")
(push '("\\.rb$" . ruby-mode) *auto-mode-alist*)

; bat-mode
(in-package "editor")
(export 'bat-mode)
(autoload 'bat-mode "bat-mode" t)
(pushnew '("\\.bat$" . bat-mode) *auto-mode-alist* :test 'equal)
(in-package "user")

; asm-mode
(in-package "editor")
(export 'asm-mode)
(autoload 'asm-mode "asm-mode" t)
(pushnew '("\\.asm$" . asm-mode) *auto-mode-alist*)
(in-package "user")

; PowerShell-mode
(require "powershell-mode")
(pushnew '("\\.ps1$" . powershell-mode) *auto-mode-alist* :key #'car)
(pushnew '("\\.psm$" . powershell-mode) *auto-mode-alist* :key #'car)

; bash-mode
(in-package "editor")
(export 'bash-mode)
(autoload 'bash-mode "bash-mode" t)
(pushnew '("\\.sh$" . bash-mode) *auto-mode-alist* :test 'equal)
(in-package "user")
(setq *bash-indent-tabs-mode* nil)

; js-mode
(load-library "js-mode")
(pushnew '("\\.js$" . js-mode) *auto-mode-alist*)

; json-mode
(load-library "json-mode")
(pushnew '("\\.json$" . json-mode) *auto-mode-alist*)

; markdown-moode
(load-library "markdown-mode")
(push '("\\.md$" . markdown-mode) *auto-mode-alist*)

; hexl-mode
;; hexl.exe のあるディレクトリ（PATH が通っていれば要らない）
;(setq hexl-exec-directory "C:/local/bin/")

;; ロード
;(load-library "hexl")


; ac-mode
(require "ac-mode")

(add-hook '*c-mode-hook*
          #'(lambda ()
              (ac-mode-on)
              (setf *ac-mode-command-list*
                    '(ac-mode-try-complete-file
                      ac-mode-try-abbrev-global
                      ac-mode-try-complete-variable
                      ac-mode-try-complete-xtags
                      ac-mode-try-dabbrev-all-buffer))))

(add-hook '*c++-mode-hook*
          #'(lambda ()
             (ac-mode-on)
              (setf *ac-mode-command-list*
                    '(ac-mode-try-complete-file
                      ac-mode-try-abbrev-global
                      ac-mode-try-complete-variable
                      ac-mode-try-complete-xtags
                      ac-mode-try-dabbrev-all-buffer))))

(add-hook '*py-mode-hook*
          #'(lambda ()
             (ac-mode-on)
              (setf *ac-mode-command-list*
                    '(ac-mode-try-complete-file
                      ac-mode-try-abbrev-global
                      ac-mode-try-complete-variable
                      ac-mode-try-complete-xtags
                      ac-mode-try-dabbrev-all-buffer))))

(add-hook '*ruby-mode-hook*
          #'(lambda ()
             (ac-mode-on)
              (setf *ac-mode-command-list*
                    '(ac-mode-try-complete-file
                      ac-mode-try-abbrev-global
                      ac-mode-try-complete-variable
                      ac-mode-try-complete-xtags
                      ac-mode-try-dabbrev-all-buffer))))

(add-hook '*js-mode-hook*
          #'(lambda ()
             (ac-mode-on)
              (setf *ac-mode-command-list*
                    '(ac-mode-try-complete-file
                      ac-mode-try-abbrev-global
                      ac-mode-try-complete-variable
                      ac-mode-try-complete-xtags
                      ac-mode-try-dabbrev-all-buffer))))


; NetInstaller
(require "ni/setup")
(ni-autoload)
;; use proxy
;(setq ni::*http-proxy-host* "192.168.1.13")
;(setq ni::*http-proxy-port* 8080)


; my-folding.l
(require "my-folding")

;; calcで小数を許可
(setq ed::*calc-ratio* 'float)

;; diff.exeへのパス
;; "etc/diff.exe"にしたらダメだった…なぜ？
(setq ed::*diff-command-name*
      (map-slash-to-backslash (merge-pathnames "C:/Files/bin/diff.exe" (user-homedir-pathname))))

