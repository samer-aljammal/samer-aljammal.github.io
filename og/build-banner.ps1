# Renders og/linkedin-banner.html to og/linkedin-banner.png (1584x396).
$edge = @(
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { Test-Path $_ } | Select-Object -First 1
if (-not $edge) { throw "Microsoft Edge not found" }

$uri = ([System.Uri](Resolve-Path "$PSScriptRoot\linkedin-banner.html").Path).AbsoluteUri
$out = [System.IO.Path]::GetFullPath("$PSScriptRoot\linkedin-banner.png")

& $edge --headless=new --disable-gpu --hide-scrollbars --window-size=1584,396 `
  --force-device-scale-factor=1 --virtual-time-budget=5000 --screenshot="$out" $uri | Out-Null
Start-Sleep -Milliseconds 500
if (-not (Test-Path $out)) { throw "PNG was not written" }
Write-Output "Wrote $out"
