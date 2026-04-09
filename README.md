# Claude Pokemon

A macOS Dynamic Island (notch) app that shows a Pokemon buddy when Claude Code is working. Built with pure SwiftUI + AppKit, zero dependencies.

## Features

- **Dynamic Island integration** — Pokemon lives in your MacBook's notch area
- **Physics-based animation** — Claude spinner ball bounces around, Pokemon kicks/headbutts/jumps to interact with it
- **Permission interception** — Claude Code permission requests show as an expandable notch popup (auto-dismisses when terminal is focused)
- **Gacha capture system** — Earn capture chances through tool usage, collect all 151 Pokemon from Pokemon Yellow
- **Pokedex** — Menu bar shows caught Pokemon in capture order, switch active Pokemon anytime
- **Click interaction** — Click the Pokemon area for an excited reaction + Pokeball wiggle

## Pokemon Rarity Distribution (151 total)

| Rarity | Drop Rate | Count |
|--------|-----------|-------|
| Common | 40% | ~36 |
| Uncommon | 30% | ~63 |
| Rare | 18% | ~37 |
| Epic | 9% | ~12 |
| Legendary | 3% | 2 (Mewtwo, Mew) |

## Capture System

- Tool usage earns points: Edit/Write/Bash = 3pts, Read/Grep/Glob = 1pt
- At 100 points, earn a capture chance
- 10 free captures on first launch
- Duplicates give +20 bonus points

## Build & Install

```bash
make          # Build
make install  # Install to /Applications
make run      # Build and launch
make clean    # Clean build artifacts
```

Requires macOS 13+ with a notch display (MacBook Pro 14"/16", MacBook Air M2+).

## Architecture

```
Claude Code  -->  claude-island-state.py  -->  Unix Socket  -->  ClaudePokemon.app
                  (hook script)               /tmp/claude-island.sock
```

### Project Structure

```
claude-pokemon/
  App/            — App entry point, AppDelegate, status bar menu
  Window/         — NotchWindow (NSPanel), NotchContentView, ScreenGeometry
  Views/          — ExpandedNotchView (permissions), PokemonSpriteView (pixel art)
  Pokemon/        — PokemonCharacter (151 species, pixel art, gacha), SpriteAnimator
  IPC/            — SocketServer, SessionManager, SessionState
```

## Requirements

- macOS 13+
- MacBook with notch display
- Claude Code with hooks configured (`~/.claude/hooks/claude-island-state.py`)
