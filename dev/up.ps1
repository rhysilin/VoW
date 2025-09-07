Param(
  [switch]$Recreate
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$envFile = Join-Path $root '.env'
$compose = Join-Path $PSScriptRoot 'docker-compose.yml'

if (-not (Test-Path $envFile)) {
  Write-Host "[dev] .env not found, creating from .env.example..."
  Copy-Item (Join-Path $root '.env.example') $envFile -Force
}

if ($Recreate) {
  Write-Host "[dev] Recreating stack (down -v)..."
  docker compose -f $compose --env-file $envFile down -v
}

Write-Host "[dev] Starting services..."
docker compose -f $compose --env-file $envFile up -d --remove-orphans

Write-Host "[dev] Done. URLs:"
Write-Host "  Directus:   http://localhost:8055"
Write-Host "  MinIO S3:   http://localhost:9000"
Write-Host "  MinIO UI:   http://localhost:9001"
Write-Host "  Yjs WS:     ws://localhost:$(Get-Content $envFile | % { if ($_ -match '^YJS_PORT=(\d+)') { $matches[1] } })"
