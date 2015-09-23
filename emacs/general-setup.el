;;; -*- Mode: Emacs-Lisp ; Coding: utf-8-dos -*-
;;;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
;;; "general-setup.el" --- 全般的な設定をする (NTEmacs 24.5.1 対応)
;;; https://github.com/chuntaro/NTEmacs64 の emacs-24.5-IME-patched.zip を使用
;;;──────────────────────────────────────
;;; Author:  amamiz <amamiz@users.noreply.github.com>
;;; Date:    Sep 23, 2015
;;;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

;;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
;; 言語環境 / 文字コードなどの設定
;;     M-x describe-coding-system RET RET で確認できる
;;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

;; 言語環境を日本語にする
(set-language-environment "Japanese")

;; IMEに関する設定
(setq default-input-method "W32-IME")
(setq-default w32-ime-mode-line-state-indicator "[--]")
(setq w32-ime-mode-line-state-indicator-list '("[--]" "[あ]" "[--]"))
(w32-ime-initialize)
;(setq w32-ime-buffer-switch-p nil)

;; IMEがONの時にカーソルの色を変える
;;      → バッファを切り替えるとうまくいかないので保留
;(add-hook 'w32-ime-on-hook  (lambda() (set-cursor-color "brown")))
;(add-hook 'w32-ime-off-hook (lambda() (set-cursor-color "black")))

;; site-lispディレクトリのパス
(setq site-lisp-directory (expand-file-name "../../../../share/emacs/site-lisp/" exec-directory))

;; UTF-8の変換テーブル修正
(mapc
 (lambda (coding-system)
   (coding-system-put coding-system :decode-translation-table
		      '(japanese-ucs-jis-to-cp932-map))
   (coding-system-put coding-system :encode-translation-table
		      '(japanese-ucs-cp932-to-jis-map)))
 '(utf-8 utf-16le))

;; ISO-2022-JP, EUC-JP, SJISの変換テーブル修正
(mapc
 (lambda (coding-system)
   (coding-system-put coding-system :decode-translation-table
		      '(cp51932-decode japanese-ucs-jis-to-cp932-map))
   (coding-system-put coding-system :encode-translation-table
		      '(cp51932-encode japanese-ucs-cp932-to-jis-map)))
 '(iso-2022-jp euc-jp japanese-shift-jis))

;; IME を無効にするもの
(wrap-function-to-control-ime 'universal-argument t nil)
(wrap-function-to-control-ime 'read-char nil nil)
(wrap-function-to-control-ime 'read-string nil nil)
(wrap-function-to-control-ime 'read-from-minibuffer nil nil)
(wrap-function-to-control-ime 'y-or-n-p nil nil)
(wrap-function-to-control-ime 'yes-or-no-p nil nil)
(wrap-function-to-control-ime 'map-y-or-n-p nil nil)

;;;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
;;; キー/マウスカスタマイズ
;;;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

;; BS を DEL にする
(keyboard-translate ?\C-h ?\C-?)

;; M-? で help
(global-set-key "\M-?" 'help-command)

;; M-p / M-n でカーソルを動かさずにスクロールする
(define-key global-map "\M-p" (lambda () (interactive) (scroll-down 1)))
(define-key global-map "\M-n" (lambda () (interactive) (scroll-up 1)))

;; その他のキーカスタマイズ
(global-set-key [f1] 'make-frame)	; F1 で新しいフレームを作る
(global-set-key [f2] 'delete-frame)	; F2 で今使っているフレームを閉じる
(global-set-key [f3] 'other-frame)	; F3 で別のフレームに移動する
(global-set-key [f4] 'other-window)	; F4 で別のウィンドウに移動する
(global-set-key [f12] 'next-error)	; F12 で次のエラーへ
(global-set-key [S-non-convert] 'w32-ime-toroku-region)	; S-無変換 で単語登録
(global-set-key [home] 'beginning-of-buffer)	; Home でバッファの先頭
(global-set-key [end] 'end-of-buffer)		; End  でバッファの最後
(global-set-key [?\C-\S-l] 'font-lock-fontify-buffer)	; C-S-l で強制色付け
(global-set-key "\C-cl" 'linum-mode)		; C-c l で行番号を表示
(global-set-key "\C-cw" 'whitespace-mode)	; C-c w で空白などを表示

;; ホイールマウスの右ボタンと中ボタンを入れ替える
(setq w32-swap-mouse-buttons t)

;; マウスのセンターボタンでポップアップメニューを開く
(global-set-key [mouse-3] 'mouse-popup-menubar-stuff)

;; URL 上で Shift + マウスの右ボタンで Web ブラウザを開く
(global-set-key [S-mouse-2] 'browse-url-at-mouse)

;; マウスでペーストする時に、マウス位置ではなくカーソル位置にする
(setq mouse-yank-at-point t)

;; マウスで選択するとコピー扱いになる（Emacs23までと同じ挙動）
(setq mouse-drag-copy-region t)

;; マウスのペーストもキーボードのペーストと同じにする（Emacs23までの同じ挙動）
(global-set-key [mouse-2] 'mouse-yank-at-click)

;; isearch 中に C-d でカーソルのある場所の文字を取り込む
;;   see http://migemo.namazu.org/ml/msg00033.html
(defun isearch-yank-char ()
  "Pull next character from buffer into search string."
  (interactive)
  (isearch-yank-string
   (save-excursion
     (and (not isearch-forward) isearch-other-end
	  (goto-char isearch-other-end))
     (buffer-substring (point) (1+ (point))))))
(define-key isearch-mode-map "\C-d" 'isearch-yank-char)

;; C-c t で、TAB 幅を 8 と 4 でトグルする
(defun toggle-tab-width ()
  "Toggle TAB width between '8' and '4'."
  (interactive)
  (setq tab-width (if (= tab-width 8) 4 8))
  (font-lock-fontify-buffer)   ; 再描画して欲しいだけ
  (message "TAB width: %d" tab-width))
(global-set-key "\C-ct" 'toggle-tab-width)

;; I-search時にもIME ONにできるようにする
;; https://highmt.wordpress.com/2010/10/25/isearch%E3%81%A7%E6%97%A5%E6%9C%AC%E8%AA%9E%E5%85%A5%E5%8A%9B%E3%82%92%E3%82%84%E3%82%8A%E3%82%84%E3%81%99%E3%81%8F%E3%81%99%E3%82%8B%E3%83%91%E3%83%83%E3%83%81/
;; http://d.hatena.ne.jp/ksugita0510/20110103
;; http://www49.atwiki.jp/ntemacs/pages/45.html
(defun w32-isearch-update ()
  (interactive)
  (isearch-update))
(define-key isearch-mode-map [compend] 'w32-isearch-update)
(define-key isearch-mode-map [kanji] 'isearch-toggle-input-method)
(add-hook 'isearch-mode-hook
          (lambda () (setq w32-ime-composition-window (minibuffer-window))))
(add-hook 'isearch-mode-end-hook
          (lambda () (setq w32-ime-composition-window nil)))

;;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
;; 全体的な設定
;;━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
;; モードラインに現在の何桁めかを表示する
(column-number-mode t)

;; 1 行ずつスクロールする（スムーススクロール）
(setq scroll-conservatively 10)

;; スクロール高速化
(setq redisplay-dont-pause t)

;; アクティブでないウィンドウにはカーソルを表示しない
(setq-default cursor-in-non-selected-windows nil)

;; 画像ファイルなどは、画像として表示する
(auto-image-file-mode t)

;; なぜかスタートアップメッセージを表示する（デフォルト）と、
;; Find File の初期ディレクトリが ~/ ではなくて D:\home\amamiz のようになるので
;; スタートアップメッセージの表示をしない
(setq inhibit-startup-message t) 

;;──────────────────────────────────────
;; バックアップファイルの設定
;;──────────────────────────────────────
(setq make-backup-files t)      ; バックアップファイルを作成する
(setq version-control t)        ; バックアップファイルに連番を付ける
(setq kept-old-versions 1)      ; 1番古いバックアップを取っておく
(setq kept-new-versions 2)      ; 新しい方2つ分のバックアップを取っておく
(setq delete-old-versions t)    ; 要らないバックアップファイルは無条件に消す
(setq vc-make-backup-files t)	; VC管理下のファイルでもバックアップする

;;──────────────────────────────────────
;; フレーム表示に関する設定
;;──────────────────────────────────────

;; ツールバーを表示しない
(tool-bar-mode 0)

;; デフォルトフォントの設定
(set-face-font 'default "MeiryoKe_Console-12")

;; 行間の設定
(setq-default line-spacing 0.15)

;; フレームの設定
(setq default-frame-alist
      (append (list
               '(left             . 10)			; フレームのＸ座標位置
               '(top              . 10)			; フレームのＹ座標位置
               '(width            . 80)			; フレームの横幅
               '(height           . 47)			; フレームの高さ
               '(foreground-color . "black")		; 文字の色
               '(background-color . "#fffff0")		; 背景の色
               '(cursor-color     . "black")		; カーソルの色
               ) default-frame-alist))

;; フレームタイトルの設定
(setq frame-title-format `("%b " (buffer-file-name "(%f) ")))

;; Alt+↑/Alt+↓でフォントサイズを大きく/小さくする
(global-set-key [M-up] 'text-scale-increase)
(global-set-key [M-down] 'text-scale-decrease)

;;──────────────────────────────────────
;; ibuffer
;;     buffer-menu の高機能版
;;──────────────────────────────────────
; C-x C-b を list-buffers ではなく ibuffer に変える
(require 'ibuffer)
(define-key ctl-x-map  "\C-b" 'ibuffer)

;;──────────────────────────────────────
;; generic-x
;;     色々なモードで色を付ける
;;──────────────────────────────────────
(require 'generic-x)

;;──────────────────────────────────────
;; cc-mode
;;──────────────────────────────────────
(defun my-c-mode-common-hook()

  ;; プログラミング言語 C++ のスタイルにする
  (c-set-style "stroustrup")

  ;; 改行した時、自動的にインデントする
  (define-key c-mode-base-map "\C-m" 'newline-and-indent)

  ;; BackSpace を押した時、TAB をスペースに分解しない
  (define-key c-mode-base-map "\177" 'delete-backward-char)

  ;; TAB キーを押した時、行頭ならインデント、それ以外なら本当の TAB にする
  (setq c-tab-always-indent nil)

  ;; インデントはTABコードを使わずすべてスペースを使う
  (setq indent-tabs-mode nil)

  ;; # を入力すると、自動的に左端に寄る機能を有効にする
  (setq c-electric-pound-behavior (list 'alignleft))
  )

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; .hファイルもc++-modeにする
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))

;;──────────────────────────────────────
;; cperl-mode
;;──────────────────────────────────────
(defalias 'perl-mode 'cperl-mode)

(add-hook 'cperl-mode-hook
	  (lambda()
	    ;; インデントスタイルを PerlStyle にする
	    (cperl-set-style "PerlStyle")

	    ;; 改行した時、自動的にインデントする
	    (cperl-define-key "\C-m" 'newline-and-indent)

	    ;; TAB キーを押した時、行頭のみインデント動作する
	    (setq cperl-tab-always-indent nil)

	    ;; BackSpace を押した時、TAB をスペースに分解しない
	    (setq cperl-electric-backspace-untabify nil)

	    ;; font-lock を有効にする
	    (setq cperl-font-lock t)))

;;──────────────────────────────────────
;; filecache
;;     指定したディレクトリ以下のファイルは常に補完対象になる
;;     これらを補完したい時は C-i の代わりに C-c C-i を使う
;;──────────────────────────────────────
(require 'filecache)

;; 下記が補完対象ディレクトリ
(file-cache-add-directory-list
 (list "~" (expand-file-name "local/" site-lisp-directory)))

;; C-c C-i でキャッシュした候補を使う
(define-key minibuffer-local-completion-map
  "\C-c\C-i" 'file-cache-minibuffer-complete)

;;──────────────────────────────────────
;; dired 関係
;;──────────────────────────────────────
;; dired-x を使う
(require 'dired-x)

;; fiber を実行する
(defun exec-fiber (file &optional arg)
  (interactive "Ffiber.exe with: \nP")
  (let (command)
    (if arg
       (setq command (read-string "Command: "))
      (setq command "fiber.exe"))
    (setq file (expand-file-name file))
    (message "%s with %s." command file)
    (apply 'start-process "exec-fiber" nil (list command file))))

;; dired から fiber を呼び出す
(defun dired-exec-fiber (&optional arg)
  (interactive "P")
  (let (filename)
    (if (setq filename (dired-get-filename))
       (exec-fiber filename arg)
      (message "Not pointed file."))))

;; dired から hexl-find-file する
(defun dired-hexl-find-file ()
  (interactive)
  (let (filename)
    (if (setq filename (dired-get-filename))
       (hexl-find-file filename)
      (message "Not pointed file."))))

;; ディレクトリは先に表示する
(setq ls-lisp-dirs-first t)

;; dired 内のキーバインドの追加
(add-hook 'dired-mode-hook
         (lambda ()
           ;; BS で上のディレクトリに上がる
           (local-set-key "\177" 'dired-up-directory)
           ;; r で wdired mode に入る
           (local-set-key "r" 'wdired-change-to-wdired-mode)
           ;; \ で fiber を実行する
           (local-set-key "\\" 'dired-exec-fiber)
           ;; h で hexl-find-file する
           (local-set-key "h" 'dired-hexl-find-file)
           ;; G で dired-do-igrep する
           (local-set-key "G" 'dired-do-igrep)
           ))

;;──────────────────────────────────────
;; Ctrl+Shift+f で「フレーム最大化」と「元に戻す」をトグルする
;;	(w32-send-sys-command #xf030) ; maximize frame
;;	(w32-send-sys-command #xf020) ; minimize frame
;;	(w32-send-sys-command #xf120) ; restore frame
;;──────────────────────────────────────
(defvar toggle-frame-size-p nil)
(defun toggle-frame-size ()
  (interactive)
  (setq toggle-frame-size-p (not toggle-frame-size-p))
  (if toggle-frame-size-p
      (w32-send-sys-command #xf030)
    (w32-send-sys-command #xf120)))
(define-key global-map (kbd "C-S-f") 'toggle-frame-size)
