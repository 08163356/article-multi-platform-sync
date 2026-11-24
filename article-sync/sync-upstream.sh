#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
cd "$root"

git fetch upstream

branch="$(git rev-parse --abbrev-ref HEAD)"
if [[ "$branch" != "v2" ]]; then
  git checkout v2
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "工作区有未提交改动，先提交再同步上游。" >&2
  exit 1
fi

if ! git merge --no-edit upstream/v2; then
  echo "合并 upstream/v2 发生冲突。解决后提交并推送 origin，不要 rebase，不要强推。" >&2
  exit 1
fi

git push origin v2
echo "已把 upstream/v2 合并进 v2，并推送到 origin。"
