---
type: Playbook
title: ネスト X セッションでの日本語入力（fcitx5 + mozc）
description: fcitx5 と mozc をネストした X セッションで使う手順。ロケールが C.UTF-8 だと mozc が自動登録されないため profile の初期設定が要る。トグルは既定の Ctrl+Space。
tags: [fcitx5, mozc, ime, wslg]
timestamp: 2026-07-19T00:30:00+09:00
---

WSLg 上の XMonad セッション（[Xephyr ネスト構成](/wslg-nested-x-session.md)）で日本語入力を有効にする手順。

1. パッケージを入れる。
   `sudo apt install fcitx5 fcitx5-mozc`
2. セッション全体に IM 環境変数を与える。
   `.local/bin/xmonad-wslg` の `session_env` が `GTK_IM_MODULE=fcitx` `QT_IM_MODULE=fcitx` `XMODIFIERS=@im=fcitx` `SDL_IM_MODULE=fcitx` を設定し、fcitx5 をセッション開始時に自動起動・終了時に kill する。
3. 入力メソッドの登録を確認する。
   **このマシンはロケールが C.UTF-8 のため、fcitx5 の初回起動時の自動設定では mozc が登録されない。**
   `~/.config/fcitx5/profile` を次の内容で用意する（fcitx5 未起動時のみ。起動中は fcitx5 が終了時に上書きするので、`fcitx5-configtool` か `fcitx5-remote -r` を使う）。

```ini
[Groups/0]
Name=Default
Default Layout=us
DefaultIM=mozc

[Groups/0/Items/0]
Name=keyboard-us
Layout=

[Groups/0/Items/1]
Name=mozc
Layout=

[GroupOrder]
0=Default
```

トグルキーは fcitx5 既定の Ctrl+Space で、xmonad 側のキーバインド追加は不要（xmonad は C-Space を掴んでいない）。

動作確認は `DISPLAY=:1 fcitx5-remote`（0=IC なし、1=非アクティブ、2=アクティブ）と、端末での実入力で行う。
fcitx5 のプロセスは X 接続経由でセッションと生死を共にするが、ランチャー外から手動起動した場合は cleanup の対象にならない点に注意。
