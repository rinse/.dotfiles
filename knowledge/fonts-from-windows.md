---
type: Playbook
title: Windows インストール済みフォントを WSL 側で使う
description: /mnt/c のフォントを ~/.local/share/fonts にシンボリックリンクして fc-cache するだけで fontconfig から使える。UDEV Gothic LG はこの方法で導入した。
tags: [fonts, wsl, fontconfig]
timestamp: 2026-07-19T00:30:00+09:00
---

WSL 側にフォントを導入するとき、Windows にインストール済みならダウンロード不要で流用できる。

1. フォントの実体を探す。
   システム全体は `/mnt/c/Windows/Fonts`、ユーザー単位のインストールは `/mnt/c/Users/<ユーザー名>/AppData/Local/Microsoft/Windows/Fonts` にある。
2. 必要なファイルだけ `~/.local/share/fonts/<族名>/` にシンボリックリンクする。
   ディレクトリごと fontconfig に見せる方法もあるが、Windows フォント全走査はキャッシュ構築が重くなるので必要な族だけに絞る。
3. `fc-cache -f ~/.local/share/fonts` を実行し、`fc-list | grep <族名>` で家族名を確認する。

UDEV Gothic LG はこの手順で導入した（2026-07-19）。
fontconfig 上の家族名は `UDEV Gothic LG` で、lxterminal では `fontname=UDEV Gothic LG 10`、xmobar では `font = "xft:UDEV Gothic LG-13"` と指定する。
シンボリックリンク先は `ryena` ユーザーの Windows プロファイルなので、別マシンではリンクの張り直しが要る。
