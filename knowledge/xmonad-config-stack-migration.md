---
type: Design Decision
title: xmonad-config の stack 移行（lts-14.16 から lts-22.44）
description: system-ghc で ghcup の GHC 9.6.7 を使い、snapshot に無い xmonad 0.18 系を extra-deps で固定した。build スクリプトは getXMonadDir 削除のため sh 化した。
tags: [xmonad, stack, haskell, ghc]
timestamp: 2026-07-18T22:10:00+09:00
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

# 上流との統合（2026-07-18 解消済み）

`.xmonad` の gitlink は長く古いコミットに固定されており、上流 origin/master は 57 コミット先行していた。
2026-07-18 に origin/master（`0d2949a`）をマージして解消した（merge commit `45b2142`）。
マージ方針は「コード内容（xmonad.hs、lib/、test/、package.yaml）は上流、ツールチェーン（stack.yaml、build）はローカル」で、コンフリクトは 5 ファイルにとどまった。
ローカル側にだけ残っていた旧 `lib/Lib.hs` は、上流の `Lib.XMonad.Actions` に置き換えられているため削除が必要だった（add 同士でコンフリクトにならず、放置すると黙って残る）。

上流コード（microlens ベースの lib 群と hspec テスト約 500 行）は GHC 9.6.7 / xmonad 0.18.1 で**無修正**でコンパイルでき、依存（microlens、mtl、hspec、QuickCheck、doctest）もすべて lts-22.44 に同梱されていた。

統合後の設定の実行時依存: `x-terminal-emulator` と `x-www-browser`（update-alternatives。このマシンでは tilix と Chrome）、`xmobar`、音量操作用の `pactl` と `pavucontrol`。

ローカルのマージコミットはリモート未 push である。
dotfiles の gitlink を push する前に submodule 側を push しないと、他環境で checkout できなくなる。

セッションの起動方法は [WSLg の Xephyr ネスト構成](/wslg-nested-x-session.md)を参照。
