# Stonemachia Cheat Mod

In-game cheat menu for Stonemachia. Press **F6** to toggle queen form, god mode, auto-parry, level, jumps, mana, and Topini spawns.

**Requires [UE4SS](https://github.com/UE4SS-RE/RE-UE4SS)** and the shared **[ModMenu](https://github.com/mattdavida/ue4ss-ModMenu)** runtime.

UI is built with [ue4ss-ModMenu](https://github.com/mattdavida/ue4ss-ModMenu) — a lightweight in-game settings framework for UE4SS Lua mods. Other mod authors are welcome to adopt it.

## Installation

Extract so both folders land under your UE4SS Mods directory:

```
<Stonemachia install>\Stonemachia\Binaries\Win64\ue4ss\Mods\StoneMachiaCheatMod\
<Stonemachia install>\Stonemachia\Binaries\Win64\ue4ss\Mods\shared\ModMenu\
```

`StoneMachiaCheatMod` ships with `enabled.txt` — no `mods.txt` edit needed.

Launch the game → press **F6**.

## Menu

| Control | What it does |
|---------|----------------|
| **Jumps** | Enable extra jumps (see Jump Count). |
| **God Player** | No damage in pawn form. Toggle off restores prior multipliers. |
| **Parry on hit** | Auto-parry every hit; works in any form. Persists through death/checkpoints. |
| **Queen** | Queen form (still killable). Toggle off = pawn. Persists through death/checkpoints. |
| **More Mana** | Mana/max mana → 9999. Toggle off restores prior values. |
| **Spawn Topini** | Spawn one rat minion (click again for more). |
| **Player Level** | Preset levels (Default / 10–100 / 999 / 9999 / MAX…). Session-persistent through death. |
| **Jump Count** | Jump amount; only applies while Jumps is ON. |

## Useful combos

| Combo | Effect |
|-------|--------|
| Queen + Parry on hit | Queen kit, auto-parry every hit |
| God Player + Parry on hit | Invincible pawn with parry rewards |
| Level 9999 + Queen | High-damage queen that can still die if Parry is off |
| Jumps + high Jump Count + Queen | Airborne queen |

## Notes

- Toggles re-apply after death (~3 s). Queen and Parry also re-apply after leaving a checkpoint (~3 s).
- God Player does not cover queen damage — use Parry on hit in queen form.
- Level is session-based (survives death, not a full game restart).
- No console commands; the menu is the only interface.
