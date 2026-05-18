**Game Project Report — Suggested Title: Skybound Runner**

Authors: Noran Morad Mostafa & Moustafa Abdullah

Suggested game name: Skybound Runner

---

**1. Game Title & Team Members**
- **Title:** Skybound Runner — an engaging 2D side-scrolling platformer with collectible coins and dynamic obstacles.
- **Team Members:** Noran Morad Mostafa, Moustafa Abdullah
- **Course / Context:** (Add class, course, or submission details here if needed.)

**2. Tools & Frameworks Used**
- **Engine:** Godot Engine (project files and scenes present in the workspace: Mainn.tscn, playerr.tscn, project.godot).
- **Scripting:** GDScript (`mainn.gd`, `playerr.gd`).
- **Assets:** Custom sprites and tiles placed under `background/`, `character/`, and `obstacles/`.
- **Audio:** Sound effects and music in the `sound/` folder (e.g., `Music.wav`, `cartoon-jump.mp3`).
- **Fonts:** Pixel Game font resource (Pixel Game.otf.import).
- **Version Control / Editor:** VS Code (workspace provided), Git (recommended).

**3. Game Overview & Story / Objective**
Skybound Runner is a retro-styled 2D side-scrolling platformer in which the player controls a runner who traverses an obstacle-filled world to collect coins and reach checkpoints. The primary objective is to gather as many coins as possible while avoiding hazards (rocks, barrels, stumps) and surviving until the end of the level.

Story (compact): The protagonist hails from a small village under a dark, stormy sky. To restore light to their homeland they must ascend the Skybound Path — racing through forests and ruins while collecting ancient sky coins to power the Beacon of Dawn.

Gameplay loop:
- Traverse continuously-scrolling terrain.
- Jump and dodge obstacles; land on platforms and breakable stoneblocks.
- Collect coins to increase score and unlock level-end rewards.
- Reach the level end or survive set time to win; collisions with hazards reduce health or trigger game over.

Core mechanics:
- Movement: run, jump, possible double-jump or dash (configured via `playerr.gd`).
- Collisions: collision shapes on player and obstacles for physics interactions.
- Items: coins (collectibles) increase score and may trigger sound effects.

**4. Graphics Techniques Used**
This project uses several common 2D graphics techniques available in Godot to produce a polished visual experience.

- **Lighting:**
  - The scene uses simple ambient lighting together with region-based effects to simulate depth. For 2D, Godot's CanvasModulate and Light2D nodes can be used; in this project we use global tinting and occasional Light2D for highlights around collectible items. Light textures and blend modes help emphasize pickups and hazards.

- **Camera Transformations:**
  - A Camera2D node follows the player with smoothing enabled to create a fluid, natural camera movement. The camera uses limits to avoid showing areas outside of level bounds (see `Mainn.tscn`). Parallax backgrounds are implemented using ParallaxBackground and ParallaxLayer nodes to add a sense of depth — near layers move faster, distant layers move slower.

- **Texture Mapping:**
  - Sprites are supplied as atlas or individual PNGs placed under `character/`, `obstacles/`, and `background/`. Textures are imported as pixel-art-friendly (filtering disabled, repeat off) to preserve crispness. TileMaps or individual Sprite nodes map textures to the level geometry; `stoneblock.tscn` and `rock.tscn` are examples of tileable obstacles.

- **Shaders (if used):**
  - This project can optionally use simple CanvasItem shaders for effects such as screen tinting during damage, a pulsing glow on coins, or parallax-based color grading. If not currently in use, they are a recommended next step. A sample shader fragment that creates a soft pulse for coin highlights can be attached to the coin Sprite material.

- **Animations:**
  - AnimationPlayer and AnimatedSprite (or AnimatedSprite2D) nodes animate the player and enemies. Character sprites have frame-based animation sheets: idle, run, jump, and death animations (see files `Gunner_Black_Run.png.import`, etc.). Animation trees can blend transitions — in simpler setups an AnimatedSprite's `playing` property and animation names are driven by `playerr.gd` movement state.

Detailed notes on improvements:
- Enable Light2D with normal maps for tiles to create convincing shading; supply normal textures for `ground.png` and major obstacles.
- Add a full-screen CanvasLayer shader to emulate weather or time-of-day changes (rain, night transitions using `nightsky.jpg.import`).

**5. Screenshots of the game**
The workspace contains many visual assets that represent the game's art. Below are placeholders and links to the image assets in the project — you can replace these placeholders with real runtime screenshots captured from Godot.

- Main scene (placeholder): [Mainn.tscn](Mainn.tscn)
- Player sprite assets: [character/Gunner_Black_Run.png.import](character/Gunner_Black_Run.png.import)
- Backgrounds and parallax layers: [background/sky.jpg.import](background/sky.jpg.import), [background/ground.png.import](background/ground.png.import)
- Obstacles and coins: [obstacles/rock.png.import](obstacles/rock.png.import), [obstacles/coin.jpg.import](obstacles/coin.jpg.import)

To produce final screenshots:
1. Open the project in Godot and run the scene: open `Mainn.tscn` and press Play.
2. Use the engine's editor or OS screenshot tool to capture fullscreen or windowed frames.
3. Save screenshots into a `screenshots/` folder and replace the above placeholders with the actual files.

**6. How to run the game**
Prerequisites:
- Install Godot Engine (recommended stable 3.x or 4.x depending on the project's Godot version). Inspect `project.godot` to confirm the target engine version.
- Ensure the workspace files are placed into a single project folder (they already are in this repository root).

Run steps:
1. Open Godot.
2. In the Project Manager choose "Import" and select the `project.godot` file located in the project root (or open the folder as a new project).
3. Once imported, double-click `Mainn.tscn` in the Scene panel to load the main scene.
4. Click the Play button (or press F5). The project will run and the main scene will start. If Godot asks for the main scene, set `Mainn.tscn` as the main scene in Project Settings -> Application -> Run -> Main Scene.

Common troubleshooting:
- If sprites look blurred, open the Import tab for the texture and disable `Filter` and set `Compression Mode` to `Lossless` (or the pixel-art friendly options), then re-import.
- If sounds are missing, confirm the files under the `sound/` folder are present and referenced by the scenes. Godot may show warnings in the debugger about missing resources.

Command-line run (optional):
If you prefer to run from the command line (Godot must be installed and on your PATH):

```powershell
godot -e .
```

Replace `godot` with the appropriate executable path if necessary.

**7. Division of work among team members**
This section lists a clear division of responsibilities. Adjust hours and tasks to reflect actual contributions.

- **Noran Morad Mostafa**
  - Gameplay programming: player movement, collision handling, and scoring logic (`playerr.gd`, `mainn.gd`).
  - Level layout: placing obstacles, configuring TileMaps and scene composition (`Mainn.tscn`, `Ground.tscn`).
  - Audio integration: hooking jump and coin sounds into gameplay events.

- **Moustafa Abdullah**
  - Art integration: importing and configuring textures, sprites, and background layers.
  - UI/HUD: implementing HUD elements, score display, and menu scenes (`hud.tscn`).
  - Visual polish: parallax background setup and camera smoothing.

Suggested fairness note: Keep a shared changelog (e.g., `CHANGELOG.md`) and use Git branches for feature work; run code review before merging.

Appendix — Key file references (workspace):
- Scenes: [Mainn.tscn](Mainn.tscn), [playerr.tscn](playerr.tscn), [hud.tscn](hud.tscn)
- Scripts: `mainn.gd`, `playerr.gd` (both in project root)
- Assets folders: [background/](background/), [character/](character/), [obstacles/](obstacles/), [sound/](sound/)

Final notes and next steps:
- Replace screenshot placeholders with runtime captures saved into `screenshots/`.
- Consider adding a short gameplay video or GIF to the report to demonstrate mechanics.
- If you want, I can also generate a polished PDF from this Markdown and embed images if you provide the in-engine screenshots.

---

End of report (REPORT.md)
