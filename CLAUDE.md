# Vocab Quest - K-Pop Themed Vocabulary Game

## Project Overview
A single-file interactive HTML vocabulary game (`vocab-quest.html`) built for an 11-year-old girl. The game turns vocabulary study into a K-pop/Gen Z themed adventure through "The Lost Library" with a gacha item shop and customizable SVG wizard avatar.

## Key Files
- `vocab-quest.html` — The entire game (HTML + CSS + JS in one file, ~3400 lines)
- `wizard-preview-v3.html` — SVG wizard avatar preview (approved design, integrated into game)
- `wizard-preview-v2.html` — Earlier SVG prototype (reference only)
- `wizard-preview.html` — First SVG prototype (reference only)

## Git Info
- **Branch `master`**: Original base game (before gacha/shop features)
- **Branch `master2`**: Stable checkpoint — Phases 1-5 complete, chapters 7-18, weekly quiz mode
- **Branch `tweaks`** (CURRENT): Active development branch — same as master2 currently
- Always work on `tweaks` branch. Create a new checkpoint branch (master3, etc.) when user wants to save a version.

## Architecture & Structure (inside vocab-quest.html)
The file is organized in this order:
1. **CSS** — All styles including dark theme, animations, responsive design, gacha card effects by rarity, matching game grid
2. **HTML** — Screens: `startScreen`, `gameScreen`, `sumScreen`, `shopScreen` + gacha result overlay + parent panel
3. **JavaScript** — Data objects first, then state, then game logic, then gacha/shop logic

### Key JavaScript sections:
- `VOCAB` object — All vocabulary data, keyed by chapter number (7-18). Each entry: `{word, pos, def}`
- `SENTENCES` object — Correct sentence examples per word (uses `___WORD___` placeholder)
- `WRONG_SENTENCES` object — Tricky wrong sentences per word (variety of misuse types, NOT just opposites). Defined inline inside the sentence challenge render function.
- `PRAISE` / `ENCOURAGE` arrays — K-pop/Gen Z themed feedback messages
- `ROUND_INFO` array — Round metadata, titles, story text (4 rounds)
- `GACHA_ITEMS` — 48 items across 3 categories (hats/pets/outfits), each with `{id, name, emoji, rarity, power, powerTier, set, desc}`
- `POWER_SCALES` — Lookup table for scaled power values by tier (1-4)
- `SET_BONUSES` — 5 themed sets (Ocean, Space, K-pop, Royal, Nature) with bonus powers
- `PULL_ODDS` — Gacha pull probabilities per tier (basic/super/mega/divine)
- `ITEM_SVG_MAP` — Maps all 48 gacha item IDs to SVG render parameters `{svgType, headphones, robeHue, hatColor}`
- `S` (State object) — All game state (score, round, hearts, streak, word stats, inventory, equipped, etc.)
- `buildChapters()` — Generates chapter checkboxes. **Update `ch<=18` when adding new chapters**
- `startGame()` — Reads selected chapters + round, initializes state, calls `buildRound()`
- `buildWizard(opts)` — SVG character renderer with configurable hat/outfit/pet/headphones
- `getWizardSvgOpts(suffix)` — Reads equipped items from ITEM_SVG_MAP, returns SVG render options
- `renderMatchingGame()` — Matching grid renderer with batch processing (Round 1)
- `processAnswer()` — Handles scoring, streak, hearts, powers, auto-advance (Rounds 2-4)
- `gachaPull()` — Handles gacha pulls with rarity rolling
- `updateShopWizard()` — Renders SVG wizard + set bonus progress in shop
- `updateMiniWizard()` — Renders tiny SVG wizard in HUD
- `getActivePowers()` — Returns array of `{name, tier}` power objects from equipped items + set bonus
- `getPowerScale(powerName)` — Returns scaled value for a power based on equipped tier

## Game Design

### Round Order (4 total):
1. **Matching Game** (Round 0) — Two-column grid, click word then click matching definition (batches of 6)
2. **Word → Definition** (Round 1) — See the word, pick correct definition from 5 choices
3. **Definition → Word** (Round 2) — See the definition, pick the correct word from 5 choices
4. **Sentence Challenge** (Round 3) — Pick which of 2 sentences uses the word correctly (final boss)

### Vocabulary Data (Anne of Green Gables):
- **Chapters 7-12**: Original vocabulary set
- **Chapters 13-18**: Added week 2 (torrent, sallow, brusquely, dolefully, tribulations, bequeathed, confounded, compunction, reiterated, rigmarole, beatification, sublime, vale, garret, blithely, drollery, inflection, ostentatiously, revelled, aesthetic, cloistered, personified, supplicant, prepense, staunchly, perusal, effusion, perquisites, bedizened, tenacity, beaux, relented, estranged, consequent, irradiated, glens)
- Total: 72 words across 12 chapters

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

### Hint System (per round):
- **Round 1 (Matching)**: Shows partial definition (first clause before comma/semicolon)
- **Round 2 (Word → Def)**: Shows a correct SENTENCE using the word from SENTENCES object (NOT the definition — old version gave away the answer)
- **Round 3 (Def → Word)**: Shows first half of the word + total letter count
- **Round 4 (Sentences)**: Shows the full definition to help judge sentence correctness

### Other Features:
- **Round selector** on start screen — skip to any round
- **Chapter selector** — pick which chapters to study (checkboxes, chapters 7-18)
- **Auto-advance** between questions (no "Next" button) — correct: 2s delay, wrong: 3s delay
- **Hints** (-5 pts) — contextual per round type (see above)
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

## COMPLETED BUILD (Phases 1-4) ✅

### Phase 1: Expanded Items & Scaled Powers ✅
- 48 gacha items (16 hats, 16 pets, 16 outfits), 5 rarity tiers, 4 pull tiers
- Scaled power system with POWER_SCALES lookup table
- 5 themed set bonuses (Ocean, Space, K-pop, Royal, Nature)

### Phase 2: SVG Wizard Integration ✅
- `buildWizard(opts)` renders full SVG character with configurable hat/outfit/pet/headphones
- `ITEM_SVG_MAP` maps all 48 gacha items to SVG parameters
- `getWizardSvgOpts(suffix)` reads equipped items and returns SVG render options
- SVG wizard renders in 3 places: Shop (large), HUD (36x48px mini), Summary screen
- Old emoji rendering fully removed (OUTFIT_FX map, outfit-* CSS classes, wizard-sparkles/w-spark particles)
- Pets without dedicated SVG types use `petEmoji` fallback (rendered as SVG text element near wizard)

### Phase 3: Matching Game Round ✅
- Matching Game is now **Round 1** (index 0) — the first round played
- Two-column grid layout (words left, definitions right)
- Click word → highlight → click matching definition
- Correct: both tiles grey out (`.matched`), wrong: shake animation + red flash
- Batch-based: 6 words per batch, processes multiple batches through the queue
- Separate scoring flow (not in `processAnswer()`) — handles streaks, powers, hearts inline

### Phase 4: Polish & Integration ✅
- Round order: Matching → Word→Def → Def→Word → Sentences (reordered so matching is first)
- Round navigation: `S.round<3` for next-round, `S.round===3` for Quest Complete
- Set bonus indicator in shop UI — shows "Ocean Set 2/3" partial progress or "COMPLETE!" when full set equipped
- `shopSetBonus` div added to shop HTML
- Wizard SVG on summary screen with equipped items
- Hint system updated for all 4 rounds

### Phase 5: Weekly Quiz Mode ✅
- `WEEKLY_QUIZ` config object at top of JS — parent updates 3 values each week (label, matchWords, sentenceWords)
- Toggle on start screen hides chapter/round selectors when ON
- 2-part flow: Part 1 = Matching (bold words), Part 2 = Sentence Challenge (starred words)
- Reuses existing `renderMatchingGame()` and `renderR3()` — no new round types
- `startWeeklyQuiz()` looks up words from WEEKLY_QUIZ in VOCAB by word name
- `buildQuizRound(part)` — part 0 = matching (S.round=0), part 1 = sentences (S.round=3)
- `showRoundSummary()` handles quiz transitions: matching → sentences → complete
- Edge case: if sentenceWords is empty, matching alone = complete
- Points still earn gacha currency

## KNOWN ISSUES / NEXT STEPS

### SVG Item Visual Variety (needs work):
- **Problem**: Many gacha items map to the same SVG type, so equipping different items doesn't always change the wizard's appearance visually
- **Affected**: Most pets map to `petEmoji` fallback (only dragon + kitsune have full SVG). Some hats share `cap` or `galaxy` type. Some outfits share `blue` type.
- **Solution needed**: Add more hat SVG types (flowercrown, catears, bandana, bow, beret, tophat, beanie, hairclip) and outfit color variants (robeHue parameter) so each of the 48 items produces a visually distinct character
- **Current hat types**: galaxy, cap, crown, aurora (only 4 for 16 hats)
- **Current outfit types**: blue, sparkle, gold, celestial (only 4 for 16 outfits)
- **Current pet types**: dragon, kitsune + petEmoji fallback (only 2 real SVGs for 16 pets)

### Key JS Functions (post-build):
- `buildWizard({hat,outfit,pet,petEmoji,headphones,idSuffix})` — SVG character renderer (~230 lines)
- `getWizardSvgOpts(suffix)` — reads equipped items via ITEM_SVG_MAP, returns SVG render opts
- `renderMatchingGame()` — matching grid renderer with batch processing
- `updateShopWizard()` — renders SVG wizard + set bonus progress in shop
- `updateMiniWizard()` — renders tiny SVG wizard in HUD

## How to Add New Vocabulary

When the user uploads a new vocab photo, update these 4 things:

### 1. Add to `VOCAB` object
```js
19:[
  {word:'newword', pos:'v.', def:'the definition'},
  // ... more words
],
```

### 2. Update `buildChapters()` range
Change `ch<=18` to `ch<=19` (or whatever the new max chapter is).

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

### 5. Update `WEEKLY_QUIZ` config
Update the 3 values in the `WEEKLY_QUIZ` object at the top of the `<script>` section:
```js
const WEEKLY_QUIZ={
  label:'Ch 19–24 Quiz',          // display label
  matchWords:['word1','word2',...], // bold words from teacher's list
  sentenceWords:['word3','word4']   // starred* words from teacher's list
};
```
The words must already exist in VOCAB (they will, since you add them in steps 1-4 above).

## Design Decisions & Lessons Learned
- **No "Next" button** — auto-advance keeps momentum high for kids
- **Wrong sentences must be tricky** — silly/absurd wrongs made it too easy to guess
- **Variety in wrong sentence types** — if all wrongs are just "opposite meaning," that's guessable
- **Feedback overlay timing** — 1.8s correct, 2.7s wrong (cheerBoost pet extends to 2.5s)
- **Font size matters** — increased from initial design for readability
- **Hints should NOT give away the answer** — Word→Def round originally showed partial definition which was basically the answer. Now shows a correct sentence from SENTENCES for context instead.
- **Hint strategy per round**: Matching=partial def, Word→Def=sentence context, Def→Word=partial word+length, Sentences=full definition
- **Round selector** — lets parents/kids skip to harder rounds
- **Matching game first** — easiest round first builds confidence, sentence challenge last as "final boss"
- **Scaled powers > unique powers** — with 48 items, using the same power types at different strengths avoids running out of unique abilities
- **Set bonuses drive collection** — motivates collecting specific items, not just chasing highest rarity
- **SVG > emoji for customization** — emoji can't be modified, SVG layers can be swapped per item
- **Composable SVG primitives** — base shapes with color params cover items without code bloat
- **Pet emoji fallback** — pets without dedicated SVG types render their emoji as SVG text near the wizard, better than showing nothing

## User Preferences
- Parent is building this for their 11-year-old daughter
- Child likes K-pop (Stray Kids, Ateez specifically)
- Gen Z slang is preferred for all UI text and feedback
- Vocabulary comes from **Anne of Green Gables** study guide, chapter-based
- User uploads new vocab photos each week — just upload in chat and say "add this week's vocab"
- Game runs as a local HTML file (no server needed)
- Character should look youthful — brown braided hair, glasses, freckles (NOT old wizard)
- Gacha items should visually change the wizard character (SVG layer swapping)
- Mid-game story popups were removed as distracting
- Matching game should be the first/easiest round, sentence challenge is the final boss
