# Vocab Quest - K-Pop Themed Vocabulary Game

## Project Overview
A single-file interactive HTML vocabulary game (`vocab-quest.html`) built for an 11-year-old girl. The game turns vocabulary study into a K-pop/Gen Z themed adventure through "The Lost Library" with a gacha item shop and customizable wizard avatar.

## Key Files
- `vocab-quest.html` — The entire game (HTML + CSS + JS in one file, ~2600 lines)
- `wizard-preview-v3.html` — SVG wizard avatar preview (approved design, NOT yet integrated into game)
- `wizard-preview-v2.html` — Earlier SVG prototype (reference only)
- `wizard-preview.html` — First SVG prototype (reference only)

## Git Info
- **Branch `master`**: Stable base game (before gacha/shop features)
- **Branch `tweaks`** (CURRENT): Active development branch with gacha shop, expanded items, scaled powers
- Always work on `tweaks` branch. Merge to `master` only when user confirms everything works.

## Architecture & Structure (inside vocab-quest.html)
The file is organized in this order:
1. **CSS** — All styles including dark theme, animations, responsive design, gacha card effects by rarity
2. **HTML** — Screens: `startScreen`, `gameScreen`, `sumScreen`, `shopScreen` + gacha result overlay + parent panel
3. **JavaScript** — Data objects first, then state, then game logic, then gacha/shop logic

### Key JavaScript sections:
- `VOCAB` object — All vocabulary data, keyed by chapter number (7-12). Each entry: `{word, pos, def}`
- `SENTENCES` object — Correct sentence examples per word (uses `___WORD___` placeholder)
- `WRONG_SENTENCES` object — Tricky wrong sentences per word (variety of misuse types, NOT just opposites)
- `PRAISE` / `ENCOURAGE` arrays — K-pop/Gen Z themed feedback messages
- `ROUND_INFO` array — Round metadata, titles, story text (currently 3 rounds, expanding to 4)
- `GACHA_ITEMS` — 48 items across 3 categories (hats/pets/outfits), each with `{id, name, emoji, rarity, power, powerTier, set, desc}`
- `POWER_SCALES` — Lookup table for scaled power values by tier (1-4)
- `SET_BONUSES` — 5 themed sets (Ocean, Space, K-pop, Royal, Nature) with bonus powers
- `PULL_ODDS` — Gacha pull probabilities per tier (basic/super/mega/divine)
- `S` (State object) — All game state (score, round, hearts, streak, word stats, inventory, equipped, etc.)
- `buildChapters()` — Generates chapter checkboxes. **Update `ch<=12` when adding new chapters**
- `startGame()` — Reads selected chapters + round, initializes state, calls `buildRound()`
- `renderR1/R2/R3` — Round-specific question renderers
- `processAnswer()` — Handles scoring, streak, hearts, powers, auto-advance
- `gachaPull()` — Handles gacha pulls with rarity rolling
- `updateShopWizard()` — Renders wizard avatar in shop (currently emoji-based, needs SVG upgrade)
- `updateMiniWizard()` — Renders mini wizard in HUD (currently emoji-based, needs SVG upgrade)
- `getActivePowers()` — Returns array of `{name, tier}` power objects from equipped items + set bonus
- `getPowerScale(powerName)` — Returns scaled value for a power based on equipped tier

## Game Design

### Current Rounds (3, expanding to 4):
1. **Word → Definition** — See the word, pick correct definition from 5 choices
2. **Definition → Word** — See the definition, pick the correct word from 5 choices
3. **Sentence Challenge** — Pick which of 2 sentences uses the word correctly
4. **Matching Game** (TO BUILD) — Grid of words and definitions, click to match pairs

### Gacha Shop System:
- **48 items** total: 16 hats, 16 pets, 16 outfits
- **5 rarity tiers**: common, rare, epic, legendary, mythic
- **4 pull tiers**: Basic (20pts), Super (50pts), Mega (100pts), Divine (250pts)
- **Dupe refunds**: common=5, rare=15, epic=30, legendary=60, mythic=125 pts
- **Scaled power system**: Each item has `powerTier` (1-4), power effects scale with tier
- **Set bonuses**: Equipping hat+outfit+pet from same set grants bonus power
- **Mythic items** grant 3 powers at once (mythicWisdom, mythicGuardian, mythicAura)

### Power Types:
| Power | Tier 1 | Tier 2 | Tier 3 | Tier 4 |
|-------|--------|--------|--------|--------|
| bonusScore | +1 pt | +2 pts | +3 pts | +5 pts |
| freeHint | 1/round | 1/round | 2/round | 3/round |
| eliminate | remove 1 | remove 2 | remove 2 | remove 3 |
| doublePoints | 1.25x | 1.5x | 1.75x | 2x |
| streakShield | 1 use | 1 use | 2 uses | 3 uses |
| restoreHeart | +1 | +1 | +1 | +2 |
| revive | 2 hearts | 2 hearts | 3 hearts | 3 hearts |
| xpMultiplier | 1.05x | 1.1x | 1.15x | 1.2x |
| wordMaster | +2 pts | +4 pts | +6 pts | +8 pts |
| comboExtender | 1 miss | 1 miss | 2 misses | 2 misses |
| luckyPull | +2% | +5% | +8% | +12% |

### 5 Set Bonuses:
- **Ocean Set** (Pirate Bandana + Sailor Dress + Library Owl) → comboExtender tier 3
- **Space Set** (Space Helmet + Space Suit + Celestial Dragon) → xpMultiplier tier 3
- **K-pop Set** (K-pop Headphones + Idol Jacket + Lucky Cat) → doublePoints tier 2
- **Royal Set** (Royal Crown + Crystal Dress + Sparkle Unicorn) → restoreHeart tier 4
- **Nature Set** (Flower Crown + Fairy Dress + Library Owl) → luckyPull tier 3

### Other Features:
- **Round selector** on start screen — skip to any round
- **Chapter selector** — pick which chapters to study (checkboxes, chapters 7-12)
- **Auto-advance** between questions (no "Next" button) — correct: 2s delay, wrong: 3s delay
- **Hints** (-5 pts) — contextual per round type
- **Hearts** — 3 per round, visual feedback on wrong answers
- **Streak combos** — fire emoji at 3x, MEGA COMBO at 5x
- **Spaced repetition** — missed words get extra copies in the pool
- **Levels** — Trainee, Rookie Idol, Main Vocalist, Center Stage, K-pop Legend
- **Parent Control Panel** — slide-out panel with score, accuracy, mastered/practice words
- **Mini wizard in HUD** — clickable, opens shop during gameplay

### Theme & Tone:
- **K-pop / Gen Z slang** — Stray Kids & Ateez inspired
- Dark purple/teal/pink/gold color palette with glassmorphism cards
- Rarity-based visual effects: mythic has rainbow color-shifting borders, legendary has gold glow, etc.

## REMAINING BUILD (Phases 2-4)

### Phase 2: SVG Wizard Integration (NEXT)
**Goal**: Replace emoji-based wizard avatar with SVG character
- **Character design**: Youthful 11-year-old girl with brown braids, glasses, purple eyes, freckles, blue robe with gold trim, staff with glowing crystal
- **Approved SVG design** is in `wizard-preview-v3.html` — the `buildWizard()` function (line 262+) takes options: `{hat, outfit, pet, headphones, idSuffix}`
- **Composable approach**: Define ~6 hat shapes, ~5 outfit shapes, ~7 pet shapes as parameterized functions with color palettes. Each of the 48 items maps to `{svgType, svgColors}`.
- **Render in 3 places**: Shop (large), HUD during game (small ~40px), Summary screen
- **Cache SVG** in `S.wizardSvgCache`, invalidate on equip change
- **Remove**: emoji rendering, OUTFIT_FX map, CSS particle classes for outfits

### Phase 3: Matching Game Round
**Goal**: Add 4th round — word-definition matching grid
- Two-column layout: words left, definitions right
- Click word → highlight → click matching definition
- Correct: both grey out with checkmark animation
- Wrong: vibration/shake + red flash → reset
- Batch-based: 6-8 words per batch
- Add to ROUND_INFO, add radio button on start screen
- `processAnswer()` gets round-3 branch (skip auto-advance)
- New `S.matchState` tracks selected tile, matched pairs

### Phase 4: Polish & Integration
- Update round navigation (`S.round<3` checks)
- Quest Complete condition: `S.round===3`
- Set bonus indicator in shop UI ("Ocean Set 2/3")
- Update this CLAUDE.md with final architecture

## How to Add New Vocabulary

When the user uploads a new vocab photo, update these 4 things:

### 1. Add to `VOCAB` object
```js
13:[
  {word:'newword', pos:'v.', def:'the definition'},
  // ... more words
],
```

### 2. Update `buildChapters()` range
Change `ch<=12` to `ch<=13` (or whatever the new max chapter is).

### 3. Add to `SENTENCES` object
```js
newword:['Correct sentence using ___WORD___ here.','Another correct sentence with ___WORD___.'],
```

### 4. Add to `WRONG_SENTENCES` object
Create 2-3 wrong sentences per word using VARIED misuse types:
- Confused with a similar-sounding word
- Used as wrong part of speech or wrong context entirely
- Subtle contradiction (sounds right but meaning doesn't fit)
- Opposite meaning (use sparingly, not as the only pattern)
- Treating it as if it means something else entirely

**Important:** Do NOT make all wrong sentences just "the opposite of the definition" — that creates a guessable pattern. Mix up the error types so the child must actually know the word.

## Design Decisions & Lessons Learned
- **No "Next" button** — auto-advance keeps momentum high for kids
- **Wrong sentences must be tricky** — silly/absurd wrongs made it too easy to guess
- **Variety in wrong sentence types** — if all wrongs are just "opposite meaning," that's guessable
- **Feedback overlay timing** — 1.8s correct, 2.7s wrong (cheerBoost pet extends to 2.5s)
- **Font size matters** — increased from initial design for readability
- **Hints must actually help** — Round 1: partial def, Round 2: first half of word + letter count, Round 3: full definition
- **Round selector** — lets parents/kids skip to harder rounds
- **Scaled powers > unique powers** — with 48 items, using the same power types at different strengths avoids running out of unique abilities
- **Set bonuses drive collection** — motivates collecting specific items, not just chasing highest rarity
- **SVG > emoji for customization** — emoji can't be modified, SVG layers can be swapped per item
- **Composable SVG primitives** — ~18 base shapes with color params cover 48 items without code bloat

## User Preferences
- Parent is building this for their 11-year-old daughter
- Child likes K-pop (Stray Kids, Ateez specifically)
- Gen Z slang is preferred for all UI text and feedback
- Vocabulary comes from chapter-based book study (appears to be a novel)
- User uploads new vocab photos each week — just upload in chat and say "add this week's vocab"
- Game runs as a local HTML file (no server needed)
- Character should look youthful — brown braided hair, glasses, freckles (NOT old wizard)
- Gacha items should visually change the wizard character (SVG layer swapping)
- Mid-game story popups were removed as distracting
