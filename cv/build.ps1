# Renders cv/cv.html to web/Samer_Aljammal_CV.pdf with headless Edge.
# Usage: powershell -File cv/build.ps1 [-Out <path>]
param([string]$Out = "$PSScriptRoot\..\web\Samer_Aljammal_CV.pdf")

$edge = @(
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $edge) { throw "Microsoft Edge not found" }

$src = (Resolve-Path "$PSScriptRoot\cv.html").Path
$out = [System.IO.Path]::GetFullPath($Out)
$uri = ([System.Uri]$src).AbsoluteUri

& $edge --headless=new --disable-gpu --no-pdf-header-footer `
  --virtual-time-budget=5000 --print-to-pdf="$out" $uri | Out-Null
Start-Sleep -Milliseconds 500
if (-not (Test-Path $out)) { throw "PDF was not written" }
Write-Output "Wrote $out"
