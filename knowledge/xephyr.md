---
type: Domain Concept
title: Xephyr とは何か、なぜ WSLg の XMonad に必要か
description: Xephyr は既存 X サーバーの 1 ウィンドウ内に完全な X サーバーを立てるネストサーバー。WSLg の rootless Xwayland では WM の前提(可視な root と SubstructureRedirect の取得)が満たせないため、Xephyr で前提を満たす X サーバーを作る。
tags: [xephyr, x11, wslg, xmonad]
timestamp: 2026-07-19T01:30:00+09:00
---

**Xephyr** は X.Org に含まれるネスト型の X サーバーである。
既存の X サーバーに対しては 1 個の X クライアントとして接続し、確保した 1 枚のウィンドウの内部を自分のスクリーンとして描画する。
一方、自分に接続してくるクライアントに対しては、root ウィンドウ・入力・RandR を備えた通常の X サーバーとして振る舞う。
つまり「外から見れば 1 ウィンドウ、中から見れば 1 画面」という二面性を持つ。

# ウィンドウマネージャが X サーバーに要求する前提

XMonad のようなウィンドウマネージャは、スクリーンの root ウィンドウに対して SubstructureRedirect を選択することで、クライアントのマップ・配置要求を横取りして自分が配置を決める。
この選択はスクリーンごとに 1 クライアントしか成功せず、既に他が取得していれば BadAccess で失敗する(「another window manager is already running」エラーの正体)。
したがって WM が動く条件は、(a) root ウィンドウとその子が実際に画面に表示されること、(b) SubstructureRedirect が空いていること、の 2 つである。

# WSLg がこの前提を満たさない理由

WSLg の X11 サポートは、Weston(Wayland コンポジタ)の上で **rootless モード**の Xwayland を動かす構成をとる。
rootless とは、X の root ウィンドウを表示せず、各トップレベルウィンドウを個別の Wayland サーフェス(= 個別の Windows ウィンドウ)として出すモードである。
このため条件 (a) が崩れる。root は概念上存在するが描画されないので、XMonad がそこにタイルを並べても何も見えない。

条件 (b) も崩れている。
Xwayland は X ウィンドウを Wayland サーフェスへ対応付けるために、コンポジタ側が **XWM**(X window manager)として振る舞うことを要求し、WSLg では Weston の XWM が既に root の SubstructureRedirect を取得している。
つまり :0 では WM の席が最初から埋まっている。

# Xephyr による解決

Xephyr を :0 のクライアントとして起動すると、WSLg から見れば Xephyr は「ただの 1 ウィンドウ」であり、rootless 構成のまま Windows デスクトップに表示される。
その内部には新しい X サーバー(:1)が生まれ、root は Xephyr ウィンドウ全面として可視、SubstructureRedirect は誰も取得していない。
XMonad を DISPLAY=:1 で起動すれば両条件が満たされ、Windows 上の 1 ウィンドウの中に完全なタイル型デスクトップが成立する。

# 検討した代替と不採用の理由

- **rootful Xwayland**(`Xwayland :1 -geometry ...`): 同じく root を 1 ウィンドウとして出せるが、Ubuntu 22.04 の Xwayland 22.1 はウィンドウ装飾(`-decorate`)に対応せず、移動・リサイズの操作性で劣る。
- **Xnest**: Xephyr の前身にあたるネストサーバーだが、RandR などの拡張対応が弱く、リサイズ追従の要件を満たせない。
- **VNC 系 X サーバー**: 仮想スクリーンは作れるが、表示がビューア経由になり遅延と操作の間接性が増す。

実際の起動手順・WSLg 固有の注意(abstract socket しか使えない点、リサイズ追従、再描画漏れへの `xrefresh`)は [WSLg で XMonad を動かすための Xephyr ネスト構成](/wslg-nested-x-session.md)を参照。
