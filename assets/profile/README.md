# Your portrait

Save your photo here as **`avatar.jpg`**:

```
assets/profile/avatar.jpg
```

That exact path is what `local_profile_repository.dart` points at via
`avatarAsset`. Until the file exists, the about section shows an initials tile
instead — no error, no broken image.

## Preparing the file

- **Square crop.** It is displayed inside a circle, so anything off-square gets
  centre-cropped with `BoxFit.cover`.
- **400x400 is plenty** — it renders at ~196 px logical, so 400 px covers a 2x
  display. Larger is wasted bytes.
- **Keep it under ~80 KB.** It loads on first paint like everything else in
  `assets/`. Export JPEG at quality ~85.
- The GitHub avatar you already have is a good source — download it at size 400
  from `https://github.com/samer-aljammal.png?size=400`.

To use a different filename or format, update `avatarAsset` in
`lib/features/profile/data/local_profile_repository.dart` to match.
