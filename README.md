# Claude Pokemon

[中文文档](README_zh.md)

A macOS Dynamic Island (notch) app that shows a Pokemon buddy when Claude Code is working. Built with pure SwiftUI + AppKit, zero dependencies.

## Demo

![demo](screenshots/demo.gif)

## Screenshots

| Collapsed (Active) | Expanded (Permission Request) |
|:---:|:---:|
| ![collapsed](screenshots/collapsed.png) | ![expanded](screenshots/expanded.png) |

## Features

- **Dynamic Island integration** — Pokemon lives in your MacBook's notch area
- **Physics-based animation** — Claude spinner ball bounces around, Pokemon kicks/headbutts/jumps to interact with it
- **Idle animation** — Pokemon hops every 3 seconds when Claude Code is not actively working
- **Permission interception** — Claude Code permission requests show as an expandable notch popup with Allow/Deny buttons
- **Gacha capture system** — Earn capture chances through tool usage, collect all 151 Pokemon from Pokemon Yellow
- **Pokedex** — Menu bar shows caught Pokemon in capture order, switch active Pokemon anytime
- **Click interaction** — Click the Pokemon area for an excited reaction + Pokeball wiggle
- **i18n** — Supports English and Chinese

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
make uninstall # Remove from /Applications
```

Requires macOS 14+ with a notch display (MacBook Pro 14"/16", MacBook Air M2+).

## Architecture

```
Claude Code hooks/client  -->  Unix Socket  -->  ClaudePokemon.app
                            /tmp/claude-island.sock
```

### Project Structure

```
claude-pokemon/
  App/            — App entry point, AppDelegate, status bar menu
  Window/         — NotchWindow (NSPanel), NotchContentView, ScreenGeometry
  Views/          — ExpandedNotchView (permissions), PokemonSpriteView (pixel art)
  Pokemon/        — PokemonCharacter (151 species, pixel art, gacha)
  IPC/            — SocketServer, SessionManager, SessionState
```

## Requirements

- macOS 14+
- MacBook with notch display
- Claude Code hooks or client integration sending session JSON to `/tmp/claude-island.sock`
