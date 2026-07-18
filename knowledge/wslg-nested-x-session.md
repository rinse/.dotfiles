---
type: Design Decision
title: WSLg で XMonad を動かすための Xephyr ネスト構成
description: WSLg の Xwayland は rootless のため WM を直接動かせず、Xephyr でネストした X サーバー上にセッションを立てる。起動は .local/bin/xmonad-wslg が担う。
tags: [wslg, xmonad, xephyr, x11]
timestamp: 2026-07-18T20:40:00+09:00
---

WSLg の X11 サーバー（Xwayland、display `:0`）は rootless で動いており、各 X クライアントのトップレベルウィンドウが個別の Windows ウィンドウとして表示される。
root ウィンドウを管理対象とするウィンドウマネージャはこの構成では動作しないため、XMonad を使うには別の X サーバーが必要になる。

採用した構成は Xephyr によるネストである。
Xephyr を `:0` のクライアントとして起動すると、Windows デスクトップ上に 1 枚のウィンドウとして現れ、その内部が独立した X サーバー（`:1` 以降）になる。
XMonad はそのネストされたディスプレイに対して起動する。

Xwayland の rootful モード（`Xwayland :1 -geometry ...`）も同じ目的に使えるが、Ubuntu 22.04 の Xwayland 22.1 はウィンドウ装飾（`-decorate`）に対応しておらず操作性が劣るため、採用しなかった。

# 環境の観察事実

- このマシンでは shell の `DISPLAY` が空だが、`WAYLAND_DISPLAY=wayland-0` と X ソケット `/tmp/.X11-unix/X0` は生きている。
  X クライアントを使うときは `DISPLAY=:0` を明示的に与える。
- **`/tmp/.X11-unix` は read-only tmpfs でマウントされている**。
  このため Xephyr はファイルシステムソケット `/tmp/.X11-unix/X1` を作れず(`_XSERVTransSocketCreateListener: failed to bind listener` の警告が出る)、Linux の abstract ソケット `@/tmp/.X11-unix/X1` だけで待ち受ける。
  接続はこれで問題なく通るが、ソケットファイルの存在確認によるディスプレイ検出は成立しない。
  空きディスプレイの探索と起動待ちは `ss -xl` で abstract ソケットも見る(実装は `.local/bin/xmonad-wslg` の `display_socket_exists`)。

# GUI アプリが Wayland 側に逃げる

GDK は `WAYLAND_DISPLAY` が**未設定でも**既定名 `wayland-0` のソケットへの接続を試み、WSLg ではこれが常に成功する。
このためネストしたディスプレイに `DISPLAY` を向けただけでは、GTK アプリは Xephyr 内ではなく Windows デスクトップに直接ウィンドウを開く。
プロセスは正常に動き続けるため、Xephyr 内にウィンドウが現れない原因としては気づきにくい。

対策として、起動スクリプトはセッション全体に次を適用する(xmonad から spawn される全アプリに継承される)。

```sh
env -u WAYLAND_DISPLAY DISPLAY=:1 GDK_BACKEND=x11 QT_QPA_PLATFORM=xcb SDL_VIDEODRIVER=x11 XDG_SESSION_TYPE=x11 <xmonad>
```

# 起動スクリプト

dotfiles の `.local/bin/xmonad-wslg`（`make install` で `~/.local/bin` にシンボリックリンクされる）が次を行う。

1. Xephyr の存在と `/tmp/.X11-unix/X0` を確認する。
2. 空きディスプレイ番号を `:1` から探す。
3. `DISPLAY=:0 Xephyr :<n> -ac -resizeable -screen <geometry>` を起動する。
   geometry は環境変数 `XMONAD_WSLG_GEOMETRY`（既定 `1920x1080`）で変えられる。
4. ソケット出現を最大 10 秒待ち、`~/.xmonad/xmonad-$(uname -m)-linux`（無ければ PATH 上の `xmonad`）を `DISPLAY=:<n>` で起動する。
5. セッション終了時に trap で Xephyr を kill する。

XMonad 側のビルドについては [xmonad-config の stack 移行](/xmonad-config-stack-migration.md)、ステータスバーの制約については [xmobar の WSL2 制約](/xmobar-wsl2-constraints.md)を参照。
