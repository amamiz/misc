#
# ".zshrc"
#

HISTFILE=~/.zsh_history		# 履歴を保存するファイル名
HISTSIZE=1000000		# メモリ上に保存する履歴の数
SAVEHIST=1000000		# ファイルに保存する履歴の数
setopt extended_history		# 履歴ファイルに時刻を記録
setopt share_history		# 複数の端末間で履歴を共有する
				# ↑コマンド実行ごとに $HISTFILE に保存する
setopt hist_ignore_space	# 先頭にスペースを入れるとヒストリに登録しない
setopt hist_ignore_dups		# 直前と同じならヒストリに登録しない
#setopt hist_ignore_all_dups	# 古いものと同じなら古いものを消す
setopt complete_in_word		# 単語の途中でもカーソル位置で補完する

setopt auto_cd			# ディレクトリ名を入力するだけで cd する
setopt auto_remove_slash	# 補完した最後の / を自動的に削除する
setopt auto_pushd		# cd した時に自動的に pushd する
setopt pushd_ignore_dups	# pushd したディレクトリをダブらせない
setopt always_last_prompt	# ^D しても、プロンプトの場所を維持する
setopt extended_glob		# 拡張したファイル名生成機能を有効にする
#setopt correct			# 入力ミスっぽい時にコマンド修正候補を表示する
setopt prompt_subst		# プロンプトに変数などが入れられる(?)
unsetopt prompt_cr		# 改行なし出力をプロンプトで上書きするのを防ぐ
setopt print_eight_bit		# 8ビット文字も補完リストに表示する

umask 022
bindkey -e			# Emacs と同じキー操作を使う
autoload -U compinit		# 賢く補完する
compinit

# 色を付けるには、\e[明るさ;色番号m / 元に戻すには、\e[0m
#	明るさ
#	0:暗い 1:明るい
#	色番号
#	30 31 32 33 34 35 36 37 
#	黒 赤 緑 黄 青 紫 水 白 
# 文字として表示されない文字列は %{...%} で囲む（プロンプト長の計算のため）

# プロンプトの設定（\e を ESC に置換するため $'...' の構文をとる
#PROMPT=$'%{\e[1;36m%}%n@%m(%T)%#%{\e[0m%} '
#RPROMPT=$'%{\e[1;33m%}[%~]%{\e[0m%}'	# 右側プロンプトの設定
PROMPT=$'%{\e[1;33m%}[%~]%{\e[0m%}%{\e[1;36m%}\n%n@%m(%T)%#%{\e[0m%} '

export LS_COLORS='di=04;37'	# ls 時のディレクトリが見にくいので色を変更

# 一覧表示を出した後に TAB で、候補を C-n, C-p, C-f, C-b で選べる
zstyle ':completion:*:default' menu select=1

# 大文字/小文字の区別なく補完する
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z} r:|[-_./]=* r:|=*'

# 小文字入力でも大文字にマッチする
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# 補間候補にも色を付ける
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

export LESS='-M -i'
#export LV='-Os -Ks'

alias ls='ls -F --show-control-chars --color=auto'
alias cp='cp -ip'
alias mv='mv -i'
alias rm='rm -i'
alias pd='popd'
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail -f'
alias hexdump='od -t x1z -Ax -v'
alias grep='grep --color --exclude=.svn'
alias start='cmd /c start'			# Cygwin 向け
alias vi='vim'

#dir () { \ls -laF $* | more }			# UNIX 向け
dir () { \ls -laFG $* | more }			# Cygwin 向け
history-all () { history -E 1 }			# 全履歴の一覧を出力
purge () { rm -i (*~|.*~|\#*\#|*.bak|.*.bak) }	# バックアップファイルを削除
hexdiff () { diff =(hexdump -v $1) =(hexdump -v $2) }
hexsdiff () { sdiff =(hexdump -v $1) =(hexdump -v $2) }

#
# zsh tips
#

# ■ extended_glob 指定時にできること
#
# ^ : 否定
# $ ls ^*.txt （*.txt 以外を表示する）
#
# ** : ディレクトリを再帰的に探索
# $ ls ** （このディレクトリ以下をすべて再帰的に表示する）
#
# (xx|yy) : または
# $ ls *.(txt|c) （*.txt または *.c を表示する）
#
# <x-y> : 数値の範囲指定
# $ ls foo<3-5>.txt （foo3.txt, foo4.txt, foo5.txt があったら表示する）
#
# (x) : 実行権のあるもの指定（r なら read 権、w なら write 権）
# $ ls *(x) （実行権のあるものだけ表示する）
#
# (.x) : 実行権のあるファイル指定
#
# $ ls *(.x) （実行権のあるファイルだけ表示する）
