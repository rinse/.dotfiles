---
okf_version: "0.1"
---

# WSLg 上の XMonad デスクトップ

* [WSLg で XMonad を動かすための Xephyr ネスト構成](wslg-nested-x-session.md) - WSLg の Xwayland は rootless のため WM を直接動かせず、Xephyr でネストした X サーバー上にセッションを立てる。起動は .local/bin/xmonad-wslg が担う。
* [xmonad-config の stack 移行（lts-14.16 から lts-22.44）](xmonad-config-stack-migration.md) - system-ghc で ghcup の GHC 9.6.7 を使い、snapshot に無い xmonad 0.18 系を extra-deps で固定した。build スクリプトは getXMonadDir 削除のため sh 化した。
* [xmobar の WSL2 制約と設定の罠](xmobar-wsl2-constraints.md) - WSL2 では coretemp が無く MultiCoreTemp が動かない。additionalFonts が空のまま &lt;fn=1&gt; を使うと xmobar 0.36 は index too large でクラッシュする。

* [ネスト X セッションでの日本語入力（fcitx5 + mozc）](japanese-input-fcitx5-wslg.md) - fcitx5 と mozc をネストした X セッションで使う手順。ロケールが C.UTF-8 だと mozc が自動登録されないため profile の初期設定が要る。トグルは既定の Ctrl+Space。

* [Windows インストール済みフォントを WSL 側で使う](fonts-from-windows.md) - /mnt/c のフォントを ~/.local/share/fonts にシンボリックリンクして fc-cache するだけで fontconfig から使える。UDEV Gothic LG はこの方法で導入した。

# リポジトリ運用

* [worktree やブランチ名に "key" を含めると権限ルールに誤マッチする](worktree-naming-deny-rules.md) - Claude Code のシークレット保護 deny ルール Read(**/*key*) はパス全体に効くため、ブランチ名由来のパスが Edit 不能になる。名前から key を外して回避する。
* [merge.ff=false 設定下では git merge --squash が失敗する](git-squash-merge-ff-config.md) - この dotfiles の .gitconfig は merge.ff=false を設定しており、--squash と衝突する。-c merge.ff=true で一時的に上書きして実行する。
