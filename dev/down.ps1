Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$root = Resolve-Path (Join-Path $PSScriptRoot '..')
$envFile = Join-Path $root '.env'
$compose = Join-Path $PSScriptRoot 'docker-compose.yml'

Write-Host "[dev] Stopping services..."
docker compose -f $compose --env-file $envFile down
Write-Host "[dev] Done."
