---
type: Gotcha
title: merge.ff=false 設定下では git merge --squash が失敗する
description: この dotfiles の .gitconfig は merge.ff=false を設定しており、--squash と衝突する。-c merge.ff=true で一時的に上書きして実行する。
tags: [git]
timestamp: 2026-07-18T19:00:00+09:00
---

この dotfiles の `.gitconfig` は `merge.ff = false` を設定している。
git はこの設定を `--no-ff` 指定として扱うため、`git merge --squash` が次のエラーで失敗する。

```
fatal: options '--squash' and '--no-ff.' cannot be used together
```

squash マージしたいときは設定を一時的に上書きする。

```sh
git -c merge.ff=true merge --squash <branch>
```

worktree を使った並列開発のマージ工程（concurrent-dev スキル）でこのリポジトリを扱うときは、毎回この形を使う。
