# Portfolio — Flutter Web

Single-page portfolio for **Samer Aljammal**, mobile app developer. Violet/magenta
neon theme, scroll-triggered entrance animations, and live phone mockups that
tilt toward the cursor while looping through real screenshots of the shipped
apps: Chattr, SpendWise, MealGo, Flowerly and Offers.

```bash
flutter pub get
flutter run -d edge          # develop (Chrome is not registered on this machine)
flutter test                 # 17 tests
flutter build web --release  # ship
```

**Copy avoids hard counts** ("4 apps", "1 year") by request — a test enforces it.
The about section makes its case through architecture principles instead.
Projects built with others carry `isCollaboration: true`, which renders a
COLLABORATION badge so shared work is never implicitly claimed as solo.

## Architecture

Feature-first, layered. UI never reaches for data directly and content never
lives inside a widget, so copy changes and redesigns stay independent.

```
lib/
├── main.dart                     # runApp only
├── app/portfolio_app.dart        # MaterialApp + theme
├── core/                         # shared, feature-agnostic
│   ├── constants/app_motion.dart # every duration and curve in the app
│   ├── di/service_locator.dart   # composition root
│   ├── responsive/               # breakpoints + context.responsive()
│   ├── scroll/                   # ScrollVisibility mixin
│   ├── theme/                    # colors, typography, ThemeData
│   ├── utils/                    # url launching
│   └── widgets/                  # GlassCard, GlowButton, RevealOnScroll, …
└── features/
    ├── profile/   domain → data → presentation
    ├── projects/  domain → data → presentation
    ├── hero/ about/ contact/ home/   (presentation only)
```

`domain` holds entities and repository interfaces. `data` holds the
implementations — currently hardcoded Dart, which is why swapping in a CMS or a
Firestore document later means writing one new class and changing one line in
`service_locator.dart`.

### Editing content

| What | Where |
|---|---|
| Name, bio, stats, socials, email, CV link | `lib/features/profile/data/local_profile_repository.dart` |
| Projects: names, copy, tech, links, screenshots | `lib/features/projects/data/local_projects_repository.dart` |
| Colors | `lib/core/theme/app_colors.dart` |
| Type scale | `lib/core/theme/app_typography.dart` |
| Animation timings | `lib/core/constants/app_motion.dart` |
| Page title, meta description, link preview | `web/index.html` |

Values marked `TODO(you)` in the two repositories are placeholders that could
not be verified — phone number, LinkedIn URL, CV link, and the headline stats.

### Adding project screenshots

Raw captures go in `screenshots_src/<app>/` (**not** bundled). Optimised copies
go in `assets/projects/` as `<project_id>_<n>.jpg` — everything in there ships in
the web bundle, so they get cropped, resized to 640 px and JPEG-compressed
first. [`assets/projects/README.md`](assets/projects/README.md) has the naming
rules and a PowerShell one-liner that does the conversion.

A project with an empty `screenshots` list renders a generated placeholder
screen instead, so the site always builds. Three tests guard the paths, because
a mistyped filename degrades to that placeholder silently rather than failing.

## How the moving parts work

**`RevealOnScroll`** fades and lifts a widget the first time it enters the
viewport, once only. `RevealOnScroll.staggered([...])` delays siblings in
sequence. It finds the enclosing scrollable through the `ScrollVisibility`
mixin rather than a visibility-detector package, which keeps the dependency
list at two packages.

**`TiltingPhoneMockup`** rotates the device toward the pointer with an
interpolated tilt — easing toward the target rather than tracking it
frame-for-frame, so it reads as an object with weight. The chassis
(`DeviceFrame`) is drawn in Dart, not imported as a PNG, which is what lets the
screen content stay live and scale to any width without a second asset.

**`ProjectScreenReel`** loops the screens inside the frame, dwelling on each
before gliding to the next, and **pauses whenever it scrolls out of view**.
With eight mockups on the page, eight always-running tickers would spend most
of the frame budget animating pixels nobody is looking at.

**`GradientOrbBackground`** drifts three colored glows on Lissajous paths,
painted as radial gradients rather than blurred layers — a real blur filter over
the full viewport costs several milliseconds per frame on Flutter web and looks
the same at this softness.

**`HighlightedText`** renders a heading whose tail is gradient-filled, as one
paragraph. The obvious approach (a `Wrap` around a plain `Text` and a gradient
one) forces a line break between them and doubles the height of every heading.

## Performance notes

Flutter web renders to a canvas, so the tradeoffs differ from an HTML site:

- **Text is not in the DOM.** `web/index.html` carries an offscreen `#seo`
  block with the essentials so crawlers have something to read.
- **First paint is slow** while the engine downloads. `web/index.html` shows a
  themed loader instead of a white flash, dismissed by a `MutationObserver`
  watching for Flutter's glass pane.
- Ambient animations sit behind `RepaintBoundary`; the nav's backdrop blur is
  only active while scrolled.

### Bundle size, honestly

`build/web` is ~41 MB on disk, but that is not what visitors download —
`canvaskit/` contains every renderer variant (36 MB) and the browser fetches
exactly one. Realistic first load:

| Part | Size |
|---|---|
| `main.dart.js` | 2.1 MB |
| one CanvasKit wasm | 3.4–6.9 MB |
| all 16 screenshots | 0.93 MB |

≈ 9–10 MB before the host's gzip/brotli (GitHub Pages compresses automatically).
`assets/NOTICES` (1.3 MB) and the `.symbols` files are not fetched on first
paint. All 16 screenshots *are*, since every mockup builds up front — which is
why they are optimised down from the 19 MB of originals.

## Testing caveat

`flutter_test` substitutes a font whose every glyph is a square of the font
size, which inflates measured line counts roughly 2x. **Do not tune type sizes
or spacing against widget-test measurements** — check them in a browser.

## Deploying

`.github/workflows/deploy.yml` builds and publishes to GitHub Pages on every
push to `main`. It runs `flutter analyze` and `flutter test` first, so a broken
commit fails the workflow instead of going live. No build output is committed.

Live at **https://samer-aljammal.github.io/**

Served from the repo `samer-aljammal.github.io`, which GitHub publishes at the
domain root. Deployment is already set up — pushing to `main` is all it takes.

### If this ever moves to a project repo

The base href in the workflow **must** match the repo name:

```yaml
- run: flutter build web --release --base-href /<repo-name>/
```

Get it wrong and the page loads blank with 404s in the console — asset requests
resolve against a path that does not exist. The current `/` is correct *only*
because the repo is named `<user>.github.io`.

The Flutter SDK version is pinned in the workflow. Bump it there when you
upgrade locally, so CI keeps building what you tested.
