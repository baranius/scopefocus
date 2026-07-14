# Cognitive Learning Game

## Pattern Matching Game for Kids with ADHD

### Project Definition
This will be a simple pattern matching game for the Kids that suffers ADHD. A demo project which proves that delivering games supporting cognitive learning is doable with the tech stack for the platforms mentioned below

### Platforms
- Web Based
- Linux (in the near future)
- Windows (TBD)
- macOS (TBD)

### Tech Stack
- flutter
- flame engine

### Hardware
- Expansive screen sizes ranging from 110″ to 160″

### Expected Features
- Click and Touch event support
- Web based version should run on full screen based on the player's decision. This is controlled by a dedicated `full_screen_button.png` button pinned to the top-right corner, visible on both the menu and playing scenes, that toggles fullscreen on/off. It is not triggered automatically by the play button.
- Layout must stay responsive: every on-screen element repositions/rescales correctly when the canvas resizes (e.g. on the fullscreen toggle), not just at initial load.


### Task
Required assets are ready to use in the `assets` folder. 

#### Scene Basics
- `background.png` is the main background screen of the game. 
- `cloud1.png` and `cloud2.png` should be floating from left to right or the opposite direction (doesn't matter).

### Beginning to the Game
- Only the `play_button.png` should be seen on the basic scene. The game should begin after the play button got clicked. 

### Game dynamics
- There are 4 different shapes (`circle`, `triangle`, `square`, `hexagon`) with 4 different color variants (`blue`, `red`, `green`, `yellow`) — 16 combinations total, e.g. `blue_circle.png`, `red_triangle.png`, etc.
- When the game begins, `seperator_line.png` should appear in the middle of the screen. This **center line is the actual drop target**: it holds 5 slot positions along its curve, each showing `expected_shape.png` as a placeholder outline until the correct piece is dropped there. Slots sit at the visual peaks/troughs of the curve's wave (not evenly spaced along a flat line) — see the artwork for exact positioning.
- On the right bottom side of the screen there should be an area with white background. 40% in width and 10% in height of the scene. It should contain the same `seperator_line.png` in a smaller size, with the round's 5 shapes already placed along it (using the same wave/peak-trough positioning as the center line). This panel is a **static, non-interactive reference only** — it shows the target pattern for the round; it is never itself a drop target.
- On the left bottom side of the screen there should be a tray of 8 draggable shapes: the 5 shapes needed to complete the round (in shuffled order) plus 3 random distractor shapes, for the player to drag onto the matching slots on the center line, in the order shown by the bottom-right reference panel.
  - Each round's 5-shape pattern is randomized (duplicate shapes/colors within a round are allowed) and regenerated every round.
  - Dropping a piece onto the wrong slot, or anywhere that isn't its correct empty slot, snaps it back to its tray origin with no penalty.
- On the left top corner there should be a mini scoreboard with background color of `#304254` and rounded corners. Inside that scoreboard the `star.png` should be placed on the left and the score on the right. Scoreboard font should be https://fonts.google.com/specimen/Fredoka?utm_source=chatgpt.com and white. 
- Each correctly placed shape increases the scoreboard by 10 points immediately (not only on full-round completion).
- Completing all 5 slots correctly is cheered with an animation of a bunch of stars exploding in the middle of the screen (particle burst using `star.png`). This full celebration animation fires once per completed round, not on every individual correct placement.
- After the celebration animation finishes, the game automatically returns to the play button scene for a new session (no manual "quit" needed).
- Scoreboard should always be seen during the game and begin to play scenes, and so should the fullscreen toggle button.