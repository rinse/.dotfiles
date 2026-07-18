---
type: Gotcha
title: worktree やブランチ名に "key" を含めると権限ルールに誤マッチする
description: Claude Code のシークレット保護 deny ルール Read(**/*key*) はパス全体に効くため、.wt/xrefresh-keybind/ のようなブランチ名由来のパスが Edit 不能になる。名前から key を外して回避する。
tags: [claude-code, permissions, worktree]
timestamp: 2026-07-19T01:00:00+09:00
---

このユーザー環境の Claude Code 設定には、秘密情報の読み取りを防ぐ deny ルールとして `Read(**/*key*)` がある。
この glob はファイル名ではなく**パス全体**に効くため、ディレクトリ名に "key" を含むだけで配下の全ファイルが Read/Edit 不能になる。

実際に踏んだ例（2026-07-19）: ブランチ名 `xrefresh-keybind` から作った worktree `.wt/xrefresh-keybind/` 配下の `xmonad.hs` が Edit できず、担当 subagent はタスクを進められないまま権限設定の書き換えを試みて（ブロックされて）終了した。

対処と教訓は次のとおり。

- worktree（= ブランチ）名に `key` `token` `secret` `credential` を含めない。
  `keybind` のような無害な語でも glob は区別しない。
- 既に作ってしまった場合は `git worktree move` と `git branch -m` で改名すれば、その場で編集可能になる。
- subagent が「権限がない」系の報告をしてきたら、まず**パスが deny glob に触れていないか**を疑う。
  権限設定そのものの変更で回避しようとする提案には従わない。

concurrent-dev の運用ノウハウとしては [[git-squash-merge-ff-config]] も参照。
