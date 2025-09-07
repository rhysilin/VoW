#requires -version 5.1
<# 
  Git 薄封装（PowerShell）v1.2
  修复/改进：
    - foreach 内的两条语句改为分行，避免解析器偶发误判
    - '@{u}' 加引号，避免被识别为哈希字面量
    - 统一使用 $gitArgs，避免覆盖自动变量 $args
    - PS5.1 控制台中文输出/读取：切换到 UTF-8
#>

# ---- 控制台编码（避免中文乱码，仅在 Windows/PS5.1 需要） ----
try {
  if ($PSVersionTable.PSVersion.Major -lt 7) {
    chcp 65001 | Out-Null  # 切换代码页到 UTF-8
    [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false)
    $PSDefaultParameterValues['Out-File:Encoding'] = 'utf8'
  }
} catch {}

# ---- 极简工具 ----
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

function _hasChanges {
  $o = git status --porcelain
  return [bool]$o   # 有输出=有改动
}

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
  # 注意：'@{u}' 必须加引号
  $null = git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>$null
  if ($LASTEXITCODE -ne 0) {
    $remote = (git remote | Select-Object -First 1); if (-not $remote) { $remote = 'origin' }
    _run @('push','-u',$remote,$branch)
  }
}

# ---- 一次性默认偏好：缺省开启 rebase/autostash（若已有设置则尊重） ----
if (-not (git config --global --get pull.rebase))      { git config --global pull.rebase true      | Out-Null }
if (-not (git config --global --get rebase.autostash)) { git config --global rebase.autostash true | Out-Null }

if (-not (_isRepo)) { Write-Host "当前目录不是 Git 仓库。请在仓库根目录运行本脚本。" -ForegroundColor Red; exit 1 }

$BR = _curBranch
Write-Host "仓库：$(Get-Location)  分支：$BR" -ForegroundColor Green

Write-Host @"
[1] 一键提交并推送（先拉取 rebase+autostash → add -A → commit → push）
[2] 一键拉取（rebase + autostash）
[3] 同步主分支（fetch → 主分支更新 → 回到当前分支 rebase 主分支）
[4] 新建并切换分支（基于主分支）
[5] 发版打标签（创建 tag 并推送）
[0] 退出
"@

$choice = Read-Host "请选择编号"
try {
  switch ($choice) {
    '1' {
      Write-Host "步骤 1/4：拉取远端（rebase + autostash）…" -ForegroundColor DarkGreen
      & git pull --rebase --autostash; if ($LASTEXITCODE -ne 0) { throw "拉取失败。" }

      Write-Host "步骤 2/4：暂存所有修改（git add -A）…" -ForegroundColor DarkGreen
      _run @('add','-A')

      if (-not (_hasChanges)) {
        Write-Host "无可提交更改。将直接尝试推送当前分支…" -ForegroundColor Yellow
        _ensureUpstream $BR
        _run @('push')
        break
      }

      Write-Host "步骤 3/4：提交…" -ForegroundColor DarkGreen
      $msg = Read-Host "提交说明（留空则使用时间戳）"
      if (-not $msg) { $msg = "chore: update $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')" }
      _run @('commit','-m',$msg)

      Write-Host "步骤 4/4：推送…" -ForegroundColor DarkGreen
      _ensureUpstream $BR
      _run @('push')
    }
    '2' {
      Write-Host "拉取（rebase + autostash）…" -ForegroundColor DarkGreen
      & git pull --rebase --autostash; if ($LASTEXITCODE -ne 0) { throw "拉取失败。" }
    }
    '3' {
      $main = _defaultBranch
      Write-Host "同步主分支：目标主分支 [$main]" -ForegroundColor DarkGreen
      _run @('fetch','--all','--prune')
      _run @('checkout',$main)
      & git pull --rebase --autostash; if ($LASTEXITCODE -ne 0) { throw "更新主分支失败。" }
      _run @('checkout',$BR)
      _run @('rebase',$main)
      Write-Host "完成。如有冲突：在 VS Code 解决后执行：git rebase --continue（放弃：git rebase --abort）" -ForegroundColor Yellow
    }
    '4' {
      $main = _defaultBranch
      $name = Read-Host "新分支名（如 feature/login）"
      if (-not $name) { break }
      _run @('fetch','--all','--prune')
      _run @('checkout',$main)
      & git pull --rebase --autostash; if ($LASTEXITCODE -ne 0) { throw "更新主分支失败。" }
      _run @('checkout','-b',$name)
      $push = Read-Host "需要立即推送并设置上游吗？(y/n，默认 n)"
      if ($push -match '^[yY]') { _ensureUpstream $name; _run @('push') }
    }
    '5' {
      $tag = Read-Host "版本号标签（如 v1.0.0）"
      if (-not $tag) { break }
      $msg = Read-Host "标签说明（可空）"
      if ($msg) { _run @('tag','-a',$tag,'-m',$msg) } else { _run @('tag',$tag) }
      $p = Read-Host "推送该标签到远端？(y/n，默认 y)"
      if ($p -notmatch '^[nN]') { _run @('push','origin',$tag) }
    }
    default { }
  }
  Write-Host "`n完成。" -ForegroundColor Green
}
catch {
  Write-Host "`n失败：$($_.Exception.Message)" -ForegroundColor Red
  Write-Host "请根据上方 Git 英文提示处理（多为冲突/权限/网络）。" -ForegroundColor Yellow
}
