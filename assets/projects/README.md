# Project screenshots

**Everything in this folder ships in the web bundle.** Full-resolution phone
screenshots are ~300 KB–1.4 MB each; the 16 files here are optimised copies
totalling under 1 MB. Original captures live in `screenshots_src/` at the
project root, which is *not* bundled — keep new originals there.

## Current files

`chattr_1..4` · `spendwise_1..4` · `mealgo_1..4` · `flowerly_1..4`

Order matters: `_1` is the first screen the phone mockup shows, so it should be
the app's most impressive view.

## Naming convention

```
<project_id>_<n>.jpg
```

The `<project_id>` must match the `id` on the `Project` in
`lib/features/projects/data/local_projects_repository.dart` — a test enforces
this, because a mismatched path silently degrades to a placeholder screen rather
than failing loudly.

## Adding a new app

1. Put the raw captures in `screenshots_src/<app>/`.
2. Pick 2–5 that tell a flow (main screen → a key feature → settings/auth).
3. Optimise them into this folder with the script below.
4. Add the `Project` entry with matching `id` and `screenshots` paths.

### Optimising (PowerShell, no extra tooling)

Crops the OS status bar, resizes to 640 px wide, saves JPEG at quality 82.
Roughly a 20x size reduction.

```powershell
Add-Type -AssemblyName System.Drawing
$in = "screenshots_src\myapp\raw.jpg"; $out = "assets\projects\myapp_1.jpg"
$img = [System.Drawing.Image]::FromFile((Resolve-Path $in))
$crop = [int]($img.Height * 0.047)          # OS status bar
$w = 640; $h = [int](($img.Height - $crop) * $w / $img.Width)
$bmp = New-Object System.Drawing.Bitmap($w, $h)
$g = [System.Drawing.Graphics]::FromImage($bmp)
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.DrawImage($img, (New-Object System.Drawing.Rectangle(0,0,$w,$h)),
             (New-Object System.Drawing.Rectangle(0,$crop,$img.Width,($img.Height-$crop))),
             [System.Drawing.GraphicsUnit]::Pixel)
$enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | ? { $_.MimeType -eq 'image/jpeg' }
$p = New-Object System.Drawing.Imaging.EncoderParameters(1)
$p.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]82)
$bmp.Save((Join-Path (Get-Location) $out), $enc, $p)
$g.Dispose(); $bmp.Dispose(); $img.Dispose()
```

## Guidance

- **Why crop the status bar:** the real clock, battery and signal icons look
  scruffy inside a mockup, and the frame draws its own dynamic island. With
  screenshots present that island is switched off (`DeviceFrame.showIsland`),
  because the app's own header now sits at the very top of the screen.
- **Aspect ratio:** portrait. The frame is 9:19.5 and crops with `BoxFit.cover`,
  so other portrait ratios are fine — they just lose a little top and bottom.
- **`.webp`** is smaller still if you have a converter to hand.
- Keep each file under ~150 KB. All of them load on first paint.

A project with an empty `screenshots` list renders a generated placeholder
screen, so the site always builds.
