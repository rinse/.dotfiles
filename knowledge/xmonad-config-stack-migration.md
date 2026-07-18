---
type: Design Decision
title: xmonad-config の stack 移行（lts-14.16 から lts-22.44）
description: system-ghc で ghcup の GHC 9.6.7 を使い、snapshot に無い xmonad 0.18 系を extra-deps で固定した。build スクリプトは getXMonadDir 削除のため sh 化した。
tags: [xmonad, stack, haskell, ghc]
timestamp: 2026-07-18T19:00:00+09:00
---

dotfiles の submodule `.xmonad`（xmonad-config リポジトリ）は resolver が lts-14.16（GHC 8.6.5、2019 年）のままで、現行環境の ghcup GHC 9.6.7 と乖離していた。
古い GHC を stack に取得させる道は Ubuntu 22.04 では libtinfo5 依存などで不安定なため、resolver を現行に上げる方針を採った。

# stack.yaml の要点

```yaml
resolver: lts-22.44
extra-deps:
- xmonad-0.18.1
- xmonad-contrib-0.18.2
system-ghc: true
compiler-check: newer-minor
```

- `system-ghc: true` と `compiler-check: newer-minor` の組で、コンパイラをダウンロードせず ghcup の GHC 9.6.7 を使う。
- **lts-22.44 には xmonad-contrib が入っていない**。
  snapshot 同梱の xmonad も 0.17.2 で、contrib 0.18.2 が xmonad >= 0.18.0 を要求するため、`extra-deps` で両方を対にして固定する必要がある。
- `stack.yaml.lock` はコミットして版を固定した。

# build スクリプトの sh 化

xmonad 0.17 で `XMonad.Core.getXMonadDir` が削除されたため、`stack runghc` ベースの旧 `build` スクリプトはコンパイルできない。
同等の処理は shell で足りるため、POSIX sh に置き換えた。

```sh
cd "$(dirname "$0")"
stack install --local-bin-path .
cp xmonad-config "xmonad-$(uname -m)-linux"
```

ファイル名 `build` は XMonad.Main.buildLaunch が参照する規約なので変えられない。
`xmonad.hs` と `lib/Lib.hs` は無修正で xmonad 0.18 に対してエラーも警告も無くコンパイルできた（`XMonad.Hooks.DynamicLog.xmobar` は deprecated だが残っている）。

# 再ビルドには X11 開発ヘッダが要る

このマシンには libx11-dev などの X11 開発パッケージが入っておらず（2026-07-18 時点）、`./build` の再実行は Haskell の X11 パッケージのビルドで失敗する。
ビルド済みバイナリ `xmonad-x86_64-linux` はランタイムライブラリだけで動くため、実行には支障がない。
再ビルドする前に次を入れる。

```sh
sudo apt install libx11-dev libxext-dev libxinerama-dev libxrandr-dev libxss-dev libxft-dev
```

# submodule と上流の分岐

`.xmonad` の gitlink は長く `63e4939` に固定されており、上流 origin/master はそこから 57 コミット先行している。
今回の移行コミットは `63e4939` からの分岐であり、上流に同種の変更が既にある可能性がある。
上流と統合するときはこの分岐を先に解消する。

セッションの起動方法は [WSLg の Xephyr ネスト構成](/wslg-nested-x-session.md)を参照。
