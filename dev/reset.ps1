Param(
  [switch]$Yes
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$envFile = Join-Path $root '.env'
$compose = Join-Path $PSScriptRoot 'docker-compose.yml'

if (-not $Yes) {
  $resp = Read-Host "[dev] This will remove containers and volumes. Proceed? (y/N)"
  if ($resp -ne 'y' -and $resp -ne 'Y') { Write-Host '[dev] Aborted.'; exit 0 }
}

Write-Host "[dev] Resetting stack (down -v)..."
docker compose -f $compose --env-file $envFile down -v
Write-Host "[dev] Done. Start again with: pwsh dev/up.ps1"
