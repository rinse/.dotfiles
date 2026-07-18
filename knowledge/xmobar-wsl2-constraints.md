---
type: Gotcha
title: xmobar の WSL2 制約と設定の罠
description: WSL2 では coretemp が無く MultiCoreTemp が動かない。additionalFonts が空のまま <fn=1> を使うと xmobar 0.36 は index too large でクラッシュする。
tags: [xmobar, wsl2]
timestamp: 2026-07-18T20:40:00+09:00
---

`.xmobarrc` を WSL2 で使うときに踏んだ制約は 2 つある。

- **MultiCoreTemp が動かない**：WSL2 カーネルには coretemp ドライバが無く、`/sys/class/hwmon` に温度センサーが現れないため、`Run MultiCoreTemp` はエラー表示になる。
  2026-07-18 に `commands` リストとテンプレートの `%multicoretemp%` を削除した。
- **XLFD フォント指定が古い**：`"-*-Fixed-*-..."` の XLFD 形式はコアフォント依存で、環境によっては解決されない。
  Ubuntu 22.04 の xmobar 0.36 では `"xft:Monospace-10"` の Xft 形式が確実に効く。

ネットワークモニタの `eth0` は WSL2 の既定 NIC 名と一致するため、変更は不要だった。

# additionalFonts が空のまま fn マークアップを使うとクラッシュする

WSL2 に固有ではないが、同じ設定ファイルで踏んだ罠を残す。
`additionalFonts = []` のまま、モニタのテンプレートに `<fn=1>↓</fn>` のようなフォント切り替えマークアップがあると、xmobar 0.36 は起動直後に次のエラーで落ちる。

```
xmobar: Prelude.!!: index too large
```

`<fn=1>` は additionalFonts リストへの添字アクセスであり、範囲チェックがない。
xmonad 経由で起動している場合、直後に xmonad 側へ `commitBuffer: resource vanished (Broken pipe)` が出るため、一見パイプの問題に見えて原因を誤認しやすい。
対処は fn マークアップを消すか、`additionalFonts` に実フォントを入れるかのどちらかで、この dotfiles では前者を採った。

このエラーの犯人探しは、モニタを 1 つずつ含む最小設定を作って `DISPLAY=:1 timeout 4 xmobar <file>` で総当たりするのが早い。
StdinReader を含む設定を端末から単体起動すると stdin の EOF で `xmobar: eof at an early stage` と出て終了するが、これは正常な動作でエラーではない。

セッション全体の構成は [WSLg の Xephyr ネスト構成](/wslg-nested-x-session.md)を参照。
