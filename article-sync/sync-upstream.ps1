$ErrorActionPreference = "Stop"
$Root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$Safe = ($Root -replace "\\", "/")

function Invoke-Git {
    & git -c "safe.directory=$Safe" -C $Root @args
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}

Invoke-Git fetch upstream

$branch = (& git -c "safe.directory=$Safe" -C $Root rev-parse --abbrev-ref HEAD).Trim()
if ($branch -ne "v2") {
    Invoke-Git checkout v2
}

$dirty = & git -c "safe.directory=$Safe" -C $Root status --porcelain
if ($dirty) {
    Write-Error "工作区有未提交改动，先提交再同步上游。"
    exit 1
}

& git -c "safe.directory=$Safe" -C $Root merge --no-edit upstream/v2
if ($LASTEXITCODE -ne 0) {
    Write-Error "合并 upstream/v2 发生冲突。解决后提交并推送 origin，不要 rebase，不要强推。"
    exit $LASTEXITCODE
}

Invoke-Git push origin v2
Write-Output "已把 upstream/v2 合并进 v2，并推送到 origin。"
