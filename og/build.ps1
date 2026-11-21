# Renders og/og-image.html to web/og-image.png (1200x630) with headless Edge.
$edge = @(
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $edge) { throw "Microsoft Edge not found" }

$uri = ([System.Uri](Resolve-Path "$PSScriptRoot\og-image.html").Path).AbsoluteUri
$out = [System.IO.Path]::GetFullPath("$PSScriptRoot\..\web\og-image.png")

& $edge --headless=new --disable-gpu --hide-scrollbars --window-size=1200,630 `
  --force-device-scale-factor=1 --virtual-time-budget=5000 --screenshot="$out" $uri | Out-Null
Start-Sleep -Milliseconds 500
if (-not (Test-Path $out)) { throw "PNG was not written" }
Write-Output "Wrote $out"
