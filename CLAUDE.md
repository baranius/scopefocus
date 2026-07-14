# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Flutter + Flame pattern-matching game demo for kids with ADHD (see `PROJECT.MD` for the original spec). Web is the primary target platform (Linux/Windows/macOS planned later). There is no backend — it's a single-screen Flame `GameWidget` app.

## Commands

A `justfile` wraps the common Flutter commands:

```
just run          # flutter run -d chrome --web-port=8765 (hot reload)
just serve         # flutter run -d web-server --web-port=8765 (no auto-launch)
just build         # flutter build web --release -> build/web
just build-serve   # release build, served locally on :8766
just analyze        # flutter analyze
just test           # flutter test
just clean          # flutter clean
```

If port 8765 is already bound by a previous run, find and kill it before retrying:
```
lsof -nP -iTCP:8765 -sTCP:LISTEN
kill -9 <pid>
```

There is no linter/formatter config beyond `flutter_lints` (see `analysis_options.yaml`); `flutter analyze` is the source of truth and should report zero issues before considering a change done.

## Architecture

### Component tree, not widget tree

Everything gameplay-related lives inside a single `PatternGame extends FlameGame` (`lib/game/pattern_game.dart`), mounted once via `GameWidget(game: PatternGame())` in `lib/main.dart`. There are no Flutter `Navigator` routes — screens are just subtrees of Flame components added/removed from the game root.

`PatternGame` has two states (`GameState.menu` / `GameState.playing`) that add/remove component subtrees rather than switching widgets:
- **menu**: `PlayButtonComponent` only.
- **playing**: `CenterLineComponent`, 5 `SlotComponent`s, `ReferencePanelComponent`, 8 `DraggableShapeComponent`s (built from a `GameRound`).

`ScoreboardComponent` and `FullscreenButtonComponent` are added once in `onLoad()` and persist across both states.

### Game concept (important — don't confuse the two separator lines)

- The **big center `seperator_line.png`** (`CenterLineComponent`) is the actual **drop target**. It has 5 `SlotComponent`s positioned along its curve, each showing `expected_shape.png` as a placeholder until the correct piece is dropped there.
- The **small white panel, bottom-right** (`ReferencePanelComponent`) is a **static, non-interactive reference** — it renders a smaller `seperator_line.png` with the round's 5 correct shapes already placed, showing the player what pattern to build. It is never a drop target.
- The **tray, bottom-left** holds 8 draggable pieces per round: the 5 correct ones (shuffled) + 3 random distractors, built by `GameRound.random()` (`lib/game/model/game_round.dart`).
- Dropping a piece on the matching, still-empty slot locks it in place and scores +10 (`PatternGame.onCorrectPlacement`). A wrong drop snaps back to origin via a `MoveToEffect`. Filling all 5 slots triggers `CelebrationComponent` (star-particle burst) and returns to the menu after a `TimerComponent` delay.

### Layout: everything is index-driven and resize-reactive

`lib/game/layout.dart` (`Layout` class) is the single source of truth for every position/size in the game, computed as fractions of `game.size` (no fixed-resolution camera — the game world *is* the canvas in pixels). There is no per-component ad-hoc math outside this file.

Notably `Layout.waveIconPositions()` places the 5 slot/reference-icon positions at the actual peaks/troughs of the `seperator_line.png` artwork (hardcoded x-fractions and trough/peak y-fractions read off the source image), not evenly spaced on a flat line — see the constants `_waveXFractions`, `_waveTroughFraction`, `_wavePeakFraction` at the top of the file. If the separator artwork ever changes, these constants need re-deriving from the new image.

**Every component that has a position or size must override `onGameResize(Vector2 size)`** and recompute itself from `Layout` + `game.size` — the engine calls this on every component in the tree whenever the canvas resizes (e.g. fullscreen toggle). There is no central resize handler in `PatternGame`; each component is self-sufficient. The pattern used everywhere:
```dart
@override
void onGameResize(Vector2 size) {
  super.onGameResize(size);
  if (isLoaded) _resize();
}
```
`SlotComponent` and `DraggableShapeComponent` take a constructor `index` specifically so they can look up their own position from `Layout.centerLineSlotPositions()` / `Layout.trayPositions()` on every resize without external help. `DraggableShapeComponent` additionally tracks `lockedSlot` so a placed piece re-snaps to its slot's new position/size on resize instead of the tray grid, and guards against repositioning mid-drag via `_isDragging`. When adding a new component with on-screen geometry, follow this same self-resizing pattern rather than setting position/size once at creation.

### Assets and image loading

Flame's image cache prefix is set once in `main.dart`: `Flame.images.prefix = 'assets/'`. Because of this, all `Sprite.load(...)` calls throughout the codebase use bare filenames (e.g. `Sprite.load('background.png')`), **not** `'assets/background.png'`. `ShapePiece.assetPath` (`lib/game/model/shape_kind.dart`) follows the same convention — it returns `'${color.name}_${kind.name}.png'`.

Shape assets are named `{color}_{shape}.png` for 4 colors (`blue`, `red`, `green`, `yellow`) × 4 shapes (`circle`, `triangle`, `square`, `hexagon`) = 16 combinations, enumerated by `ShapeColor`/`ShapeKind` in `lib/game/model/shape_kind.dart`.

The `assets/` folder is registered wholesale in `pubspec.yaml` (`assets: - assets/`), so new files dropped in there don't need a pubspec edit — just re-run `flutter pub get` if hot reload doesn't pick it up.

Fredoka font is bundled locally as `assets/fonts/Fredoka-VariableFont.ttf` (not `google_fonts`), used only by `ScoreboardComponent`'s score text.

### Web fullscreen toggle

`lib/web/fullscreen.dart` conditionally exports a stub (non-web) or `fullscreen_web.dart` (web, via `package:web`'s `dart:js_interop` bindings) based on `dart.library.js_interop`. `requestFullscreen()` toggles fullscreen on/off depending on `document.fullscreenElement`. It's wired to `FullscreenButtonComponent` (top-right, persistent) — it is **not** triggered automatically by the play button.

### Drag and drop

Built entirely on Flame's own event system (`DragCallbacks`/`TapCallbacks` from `package:flame/events.dart`), not Flutter widget-level `Draggable`/`DragTarget`. `PatternGame.findMatchingEmptySlot()` does the hit-testing (distance-based, against unfilled slots whose `target` `ShapePiece` matches).

### Audio

Uses `flame_audio` (built on `audioplayers`). Same prefix trick as images: `FlameAudio.updatePrefix('assets/')` is set once in `main.dart` so `FlameAudio.play(...)`/`FlameAudio.bgm.play(...)` calls use bare filenames under `assets/`, not `assets/audio/...` (the package's default). Audio files are `.m4a` deliberately — Chrome (the primary dev target) doesn't support `.aif`/`.aiff` at all and is unreliable with raw `.aac` streams outside an MP4/M4A container.

- `background.m4a` — looping bgm, started once via `FlameAudio.bgm.play()` (which loops automatically) on the **first** `startRound()` call (`_bgmStarted` guard). It's deliberately tied to the first play-button tap rather than app launch, since browsers block audio autoplay without a user gesture.
- `shape_match.m4a` — one-shot SFX fired in `PatternGame.onCorrectPlacement()` on every correct placement.
- `game_over.m4a` — one-shot SFX fired in `PatternGame._onRoundComplete()` alongside the star `CelebrationComponent`. Despite the filename, this is the round-complete/celebration sound, not a failure/game-over sound — there is no failure state in this game.
