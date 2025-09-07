#requires -version 5.1
<#
  Git 薄封装（PowerShell）v1.5
  目标：彻底降低“未解决冲突打断提交流程”的频率，并在发生时自动收尾
  菜单：
    [1] 一键提交并推送（预检冲突 → 拉取 rebase+autostash → add → commit → push）
    [2] 一键拉取（预检冲突 → rebase+autostash）
    [3] 同步主分支（fetch → 更新主分支 → 回到当前分支 rebase 主分支）
    [4] 新建并切换分支（基于主分支）
    [5] 发版打标签（创建 tag 并推送）
    [6] 冲突助手（支持 ours/theirs/逐个/手工，能处理删除类冲突）
    [7] Git 医生（检测并一键“继续/放弃”未完成的 rebase/merge，或直接进入冲突助手）
    [0] 退出
#>

# ---------- 控制台编码（避免中文乱码，PS5.1用） ----------
try {
  if ($PSVersionTable.PSVersion.Major -lt 7) {
    chcp 65001 | Out-Null
    [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false)
    $PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
  }
} catch {}

# ---------- 工具函数 ----------
function _assertGit {
  try { $null = git --version 2>$null } catch {
    Write-Host "未检测到 Git，请先安装：https://git-scm.com/downloads" -ForegroundColor Red
    exit 1
  }
}
function _run([string[]]$gitArgs) {
  Write-Host "`n> git $($gitArgs -join ' ')" -ForegroundColor DarkCyan
  & git $gitArgs
  if ($LASTEXITCODE -ne 0) { throw "Git 命令失败（$LASTEXITCODE）。" }
}
function _isRepo {
  $LASTEXITCODE = 0
  git rev-parse --is-inside-work-tree 2>$null | Out-Null
  return ($LASTEXITCODE -eq 0)
}
function _curBranch { git rev-parse --abbrev-ref HEAD 2>$null }
function _hasChanges { [bool](git status --porcelain) }
function _defaultBranch {
  $h = git symbolic-ref --quiet --short refs/remotes/origin/HEAD 2>$null
  if ($LASTEXITCODE -eq 0 -and $h) { return ($h -replace '^origin/','') }
  foreach ($n in 'main','master','develop') {
    git show-ref --verify --quiet "refs/heads/$n" 2>$null
    if ($LASTEXITCODE -eq 0) { return $n }
  }
  return 'main'
}
function _ensureUpstream($branch) {
  $null = git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null  # 注意：一定要引号
  if ($LASTEXITCODE -ne 0) {
    $remote = (git remote | Select-Object -First 1); if (-not $remote) { $remote = 'origin' }
    _run @('push','-u',$remote,$branch)
  }
}
function _hasUnmerged { [bool](git diff --name-only --diff-filter=U 2>$null) }
function _opInProgress {
  $gitDir = git rev-parse --git-dir 2>$null
  if (-not $gitDir) { return $false }
  return (Test-Path (Join-Path $gitDir 'MERGE_HEAD')) `
      -or (Test-Path (Join-Path $gitDir 'rebase-apply')) `
      -or (Test-Path (Join-Path $gitDir 'rebase-merge'))
}

# ---------- 默认偏好：若未设置则开启 rebase/autostash ----------
if (-not (git config --global --get pull.rebase))      { git config --global pull.rebase true      | Out-Null }
if (-not (git config --global --get rebase.autostash)) { git config --global rebase.autostash true | Out-Null }

# ---------- 一键操作 ----------
function Invoke-GitCommitPush {
  # 0) 预检：如有未解决冲突或在进行中的 rebase/merge，先走冲突助手或医生
  if (_hasUnmerged -or _opInProgress) {
    Write-Host "检测到未解决的冲突/进行中的变基或合并，先进入【冲突助手】…" -ForegroundColor Yellow
    Resolve-GitConflicts
    return
  }

  $BR = _curBranch
  Write-Host "步骤 1/4：拉取远端（rebase + autostash）…" -ForegroundColor DarkGreen
  & git pull --rebase --autostash; if ($LASTEXITCODE -ne 0) {
    if (_hasUnmerged -or _opInProgress) {
      Write-Host "拉取过程中出现冲突，切到【冲突助手】…" -ForegroundColor Yellow
      Resolve-GitConflicts
      return
    }
    throw "拉取失败。"
  }

  Write-Host "步骤 2/4：暂存所有修改（git add -A）…" -ForegroundColor DarkGreen
  _run @('add','-A')

  if (_hasUnmerged) { Write-Host "检测到未合并文件，切到【冲突助手】…" -ForegroundColor Yellow; Resolve-GitConflicts; return }

  if (-not (_hasChanges)) {
    Write-Host "无可提交更改。将直接尝试推送当前分支…" -ForegroundColor Yellow
    _ensureUpstream $BR
    _run @('push')
    return
  }

  Write-Host "步骤 3/4：提交…" -ForegroundColor DarkGreen
  $msg = Read-Host "提交说明（留空则使用时间戳）"
  if (-not $msg) { $msg = "chore: update $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" }
  _run @('commit','-m',$msg)

  Write-Host "步骤 4/4：推送…" -ForegroundColor DarkGreen
  _ensureUpstream $BR
  _run @('push')
}

function Update-GitPullRebase {
  if (_hasUnmerged -or _opInProgress) {
    Write-Host "检测到未解决的冲突/进行中的变基或合并，先进入【冲突助手】…" -ForegroundColor Yellow
    Resolve-GitConflicts
    return
  }
  Write-Host "拉取（rebase + autostash）…" -ForegroundColor DarkGreen
  & git pull --rebase --autostash; if ($LASTEXITCODE -ne 0) {
    if (_hasUnmerged -or _opInProgress) { Write-Host "拉取出现冲突 → 【冲突助手】…" -ForegroundColor Yellow; Resolve-GitConflicts; return }
    throw "拉取失败。"
  }
}

function Update-GitFromMain {
  $BR   = _curBranch
  $main = _defaultBranch
  Write-Host "同步主分支：目标主分支 [$main]" -ForegroundColor DarkGreen
  _run @('fetch','--all','--prune')
  _run @('checkout',$main)
  & git pull --rebase --autostash; if ($LASTEXITCODE -ne 0) { throw "更新主分支失败。" }
  _run @('checkout',$BR)
  _run @('rebase',$main)
  Write-Host "完成。如有冲突：在 VS Code 解决后执行：git rebase --continue（放弃：git rebase --abort）" -ForegroundColor Yellow
}

function New-GitBranchInteractive {
  $main = _defaultBranch
  $name = Read-Host "新分支名（如 feature/login）"
  if (-not $name) { return }
  _run @('fetch','--all','--prune')
  _run @('checkout',$main)
  & git pull --rebase --autostash; if ($LASTEXITCODE -ne 0) { throw "更新主分支失败。" }
  _run @('checkout','-b',$name)
  $push = Read-Host "需要立即推送并设置上游吗？(y/n，默认 n)"
  if ($push -match '^[yY]') { _ensureUpstream $name; _run @('push') }
}

function New-GitReleaseTag {
  $tag = Read-Host "版本号标签（如 v1.0.0）"
  if (-not $tag) { return }
  $msg = Read-Host "标签说明（可空）"
  if ($msg) { _run @('tag','-a',$tag,'-m',$msg) } else { _run @('tag',$tag) }
  $p = Read-Host "推送该标签到远端？(y/n，默认 y)"
  if ($p -notmatch '^[nN]') { _run @('push','origin',$tag) }
}

# ---- 冲突助手（能识别并正确处理删除/新增等冲突类型） ----
function Resolve-GitConflicts {
  Write-Host "`n【冲突助手】" -ForegroundColor Cyan

  $raw = git status --porcelain 2>$null
  $entries = @()
  foreach ($line in $raw) {
    $t = $line.Trim(); if ($t.Length -lt 4) { continue }
    if ($t -match '^([A-Z\?]{2})\s+(.+)$') {
      $code = $Matches[1]; $path = $Matches[2]
      if ($code -in @('UU','AA','DD','AU','UA','UD','DU')) {
        $entries += [pscustomobject]@{ Code=$code; Path=$path }
      }
    }
  }

  if (-not $entries -or $entries.Count -eq 0) { Write-Host "当前没有处于冲突状态的文件。" -ForegroundColor Green; return }

  Write-Host "发现冲突文件：" -ForegroundColor Yellow
  $entries | ForEach-Object { Write-Host (" - [{0}] {1}" -f $_.Code, $_.Path) }

  Write-Host @"
选择解决方式：
  1) 全部保留本地版本（ours）
  2) 全部保留远端版本（theirs）
  3) 逐个文件选择 ours/theirs
  4) 打开 VS Code 手动合并
  0) 取消
"@
  $mode = Read-Host "请选择"

  function Resolve-One([string]$choice, [string]$code, [string]$path) {
    switch ($code) {
      'UU' { if ($choice -eq 'o') { git checkout --ours -- "$path" | Out-Null } else { git checkout --theirs -- "$path" | Out-Null }; git add "$path" | Out-Null }
      'AA' { if ($choice -eq 'o') { git checkout --ours -- "$path" | Out-Null } else { git checkout --theirs -- "$path" | Out-Null }; git add "$path" | Out-Null }
      'DD' { git rm -- "$path" | Out-Null }
      'AU' { if ($choice -eq 'o') { git add "$path" | Out-Null } else { git rm -- "$path" | Out-Null } }
      'UA' { if ($choice -eq 'o') { git rm -- "$path" | Out-Null } else { git checkout --theirs -- "$path" | Out-Null; git add "$path" | Out-Null } }
      'UD' { if ($choice -eq 'o') { git rm -- "$path" | Out-Null } else { git checkout --theirs -- "$path" | Out-Null; git add "$path" | Out-Null } }
      'DU' { if ($choice -eq 'o') { git checkout --ours -- "$path" | Out-Null; git add "$path" | Out-Null } else { git rm -- "$path" | Out-Null } }
      default { if ($choice -eq 'o') { git checkout --ours -- "$path" | Out-Null } else { git checkout --theirs -- "$path" | Out-Null }; git add "$path" | Out-Null }
    }
  }

  switch ($mode) {
    '1' { foreach ($e in $entries) { Resolve-One -choice 'o' -code $e.Code -path $e.Path } }
    '2' { foreach ($e in $entries) { Resolve-One -choice 't' -code $e.Code -path $e.Path } }
    '3' {
      foreach ($e in $entries) {
        $ans = Read-Host ("文件 [{0}] {1}：o=ours / t=theirs / s=跳过" -f $e.Code, $e.Path)
        switch ($ans) {
          'o' { Resolve-One -choice 'o' -code $e.Code -path $e.Path }
          't' { Resolve-One -choice 't' -code $e.Code -path $e.Path }
          default { Write-Host "跳过 $($e.Path)" -ForegroundColor DarkYellow }
        }
      }
    }
    '4' {
      code -r .
      Read-Host "在 VS Code 解决完所有冲突并保存后，按回车继续…" | Out-Null
      foreach ($e in $entries) {
        if (Test-Path $e.Path) { git add "$($e.Path)" | Out-Null } else { git rm -- "$($e.Path)" | Out-Null }
      }
    }
    default { return }
  }

  & git rebase --continue 2>$null
  if ($LASTEXITCODE -ne 0) {
    & git merge --continue 2>$null
    if ($LASTEXITCODE -ne 0) {
      $still = git diff --name-only --diff-filter=U
      if ($still) { Write-Host "仍有未解决的冲突：" -ForegroundColor Red; $still; return }
      _run @('commit','-m','chore: resolve conflicts')
    }
  }

  _ensureUpstream (_curBranch)
  _run @('push')
  Write-Host "冲突处理完成并已推送。" -ForegroundColor Green
}

# ---- Git 医生：处理未结束的 rebase/merge、或一键进入冲突助手 ----
function Repair-GitState {
  $inprog = _opInProgress
  $unm    = _hasUnmerged
  if (-not $inprog -and -not $unm) {
    Write-Host "状态良好：无未解决冲突、无进行中的 rebase/merge。" -ForegroundColor Green
    return
  }
  Write-Host "检测到问题状态：" -ForegroundColor Yellow
  if ($inprog) { Write-Host " - 存在进行中的 rebase/merge" -ForegroundColor Yellow }
  if ($unm)    { Write-Host " - 存在未合并文件" -ForegroundColor Yellow }

  Write-Host @"
请选择处理方式：
  1) 继续（rebase --continue / merge --continue）
  2) 放弃（rebase --abort / merge --abort）
  3) 进入【冲突助手】按策略解决
  0) 取消
"@
  $mode = Read-Host "选择"
  switch ($mode) {
    '1' {
      & git rebase --continue 2>$null
      if ($LASTEXITCODE -ne 0) { & git merge --continue 2>$null }
      if ($LASTEXITCODE -ne 0) { Write-Host "无法继续，可能仍有未解决冲突。" -ForegroundColor Red }
    }
    '2' {
      & git rebase --abort 2>$null
      & git merge  --abort 2>$null
      if ($LASTEXITCODE -eq 0) { Write-Host "已放弃重叠操作。" -ForegroundColor Green }
    }
    '3' { Resolve-GitConflicts }
    default { return }
  }
}

# ---------- 菜单 ----------
function Show-Menu {
  Clear-Host
  Write-Host "仓库：$(Get-Location)  分支：$(_curBranch)" -ForegroundColor Green
  Write-Host @"
[1] 一键提交并推送（先拉取 rebase+autostash → add → commit → push）
[2] 一键拉取（rebase + autostash）
[3] 同步主分支（fetch → 主分支更新 → 回到当前分支 rebase 主分支）
[4] 新建并切换分支（基于主分支）
[5] 发版打标签（创建 tag 并推送）
[6] 冲突助手（批量 ours/theirs/逐个/手工）
[7] Git 医生（继续/放弃 rebase/merge 或进入冲突助手）
[0] 退出
"@
}

# ---------- 入口 ----------
_assertGit
if (-not (_isRepo)) { Write-Host "当前目录不是 Git 仓库。请在仓库根目录运行本脚本。" -ForegroundColor Red; exit 1 }

do {
  Show-Menu
  $choice = Read-Host "请选择编号"
  try {
    switch ($choice) {
      '1' { Invoke-GitCommitPush }
      '2' { Update-GitPullRebase }
      '3' { Update-GitFromMain }
      '4' { New-GitBranchInteractive }
      '5' { New-GitReleaseTag }
      '6' { Resolve-GitConflicts }
      '7' { Repair-GitState }
      '0' { break }
      default { Write-Host "无效选择。" -ForegroundColor Yellow }
    }
    if ($choice -ne '0') {
      Write-Host "`n操作完成。按回车返回菜单，或输入 0 退出。" -ForegroundColor DarkGreen
      $x = Read-Host
      if ($x -eq '0') { break }
    }
  } catch {
    Write-Host "`n失败：$($_.Exception.Message)" -ForegroundColor Red
    Write-Host "请根据上方 Git 英文提示处理（多为冲突/权限/网络）。" -ForegroundColor Yellow
    Read-Host "按回车返回菜单…" | Out-Null
  }
} while ($true)

Write-Host "已退出。" -ForegroundColor Green
