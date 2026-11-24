# 上游同步

这个仓库是 [Wechatsync](https://github.com/wechatsync/Wechatsync) `v2` 的一份拷贝，用来在自己的代码上改，并继续接收上游更新。

| 远程 | 地址 | 用途 |
| --- | --- | --- |
| `origin` | https://github.com/08163356/article-multi-platform-sync.git | 自己的仓库，日常推这里 |
| `upstream` | https://github.com/wechatsync/Wechatsync.git | 上游，只拉取不推送 |

跟踪分支是 `v2`，和上游默认分支同名。自己的修改直接提交在 `v2` 上。同步时用合并，不用 rebase，这样不需要强推。

`packages/core/src/adapters/platforms/private` 是上游的私有子模块，这里不拉取，同步脚本也不会进入它。

## 同步上游

工作区要是干净的，并且当前能推送到 `origin`。

Windows：

```powershell
.\article-sync\sync-upstream.ps1
```

Linux（包括 12 服务器上的这份代码）：

```bash
bash article-sync/sync-upstream.sh
```

脚本做四件事：`git fetch upstream`，切到 `v2`，`git merge upstream/v2`，成功后 `git push origin v2`。有冲突就停下来，解决后自己提交，再推送。冲突期间不要执行 `git rebase` 或 `git push --force`。
