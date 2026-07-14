# scopefocus

A pattern-matching game for kids with ADHD, built with Flutter + the Flame engine. Web is the primary target platform (Linux/Windows/macOS planned later). See `PROJECT.MD` for the full design spec.

Players drag colored shapes from a tray onto matching slots along a curved center line, guided by a static reference panel showing the target pattern. Each correct placement scores 10 points; completing a round triggers a star celebration and returns to the start screen.

## Getting started

Requires the Flutter SDK and [`just`](https://github.com/casey/just).

```
just run    # flutter run -d chrome, hot reload, http://localhost:8765
```

Other recipes (`just --list`):

- `just serve` — run as a plain web server without auto-launching Chrome
- `just build` — release web build into `build/web`
- `just build-serve` — build release and serve it locally on `:8766`
- `just analyze` — `flutter analyze`
- `just test` — `flutter test`
- `just clean` — `flutter clean`

If port 8765 is already in use from a previous run:
```
lsof -nP -iTCP:8765 -sTCP:LISTEN
kill -9 <pid>
```

## Documentation

- `PROJECT.MD` — game design spec
- `CLAUDE.md` — architecture notes and conventions for working in this codebase
