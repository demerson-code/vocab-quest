# Vocab Quest - K-Pop Themed Vocabulary Game

## Project Overview
A single-file interactive HTML vocabulary game (`vocab-quest.html`) built for a child (elementary/middle school level). The game turns vocabulary study into a K-pop/Gen Z themed adventure through "The Lost Library."

## Key Files
- `vocab-quest.html` — The entire game (HTML + CSS + JS in one file, ~1600 lines)

## Architecture & Structure (inside vocab-quest.html)
The file is organized in this order:
1. **CSS** — All styles including dark theme, animations, responsive design
2. **HTML** — Three screens: `startScreen`, `gameScreen`, `sumScreen` + story overlay + parent panel
3. **JavaScript** — Data objects first, then state, then game logic

### Key JavaScript sections:
- `VOCAB` object (~line 671) — All vocabulary data, keyed by chapter number. Each entry: `{word, pos, def}`
- `SENTENCES` object (~line 722) — Correct sentence examples per word (uses `___WORD___` placeholder)
- `WRONG_SENTENCES` object (~line 1051) — Tricky wrong sentences per word (variety of misuse types, NOT just opposites)
- `PRAISE` / `ENCOURAGE` arrays — K-pop/Gen Z themed feedback messages
- `ROUND_INFO` array — Round metadata, titles, story text
- `S` (State object) — All game state (score, round, hearts, streak, word stats, etc.)
- `buildChapters()` (~line 966) — Generates chapter checkboxes. **Update `ch<=12` when adding new chapters**
- `startGame()` — Reads selected chapters + round, initializes state, calls `buildRound()`
- `renderR1/R2/R3` — Round-specific question renderers
- `showSummary()` — End-of-round results with mastered/needs-practice breakdown

## Game Design

### Three Rounds:
1. **Word -> Definition** — See the word, pick correct definition from 5 choices
2. **Definition -> Word** — See the definition, pick the correct word from 5 choices
3. **Sentence Challenge** — Pick which of 2 sentences uses the word correctly

### Features:
- **Round selector** on start screen — skip to any round
- **Chapter selector** — pick which chapters to study (checkboxes)
- **Auto-advance** between questions (no "Next" button) — correct: 2s delay, wrong: 3s delay
- **Hints** (-5 pts) — contextual per round type
- **Scoring** — 10 pts base + streak bonuses + round 3 bonus
- **Hearts** — 3 per round, visual feedback on wrong answers
- **Streak combos** — fire emoji at 3x, MEGA COMBO at 5x
- **Spaced repetition** — missed words get extra copies in the pool
- **Levels** — Trainee, Rookie Idol, Main Vocalist, Center Stage, K-pop Legend
- **Parent Control Panel** — slide-out panel with score, accuracy, mastered/practice words
- **Adventure Mode** — story moments between rounds with Lexicon the guardian character

### Theme & Tone:
- **K-pop / Gen Z slang** — Stray Kids & Ateez inspired
- References to fan chants, lightsticks, debut eras, bias-wreckers, fancams
- Praise uses: "slay," "no cap," "ate and left no crumbs," "main character energy," etc.
- Dark purple/teal/pink/gold color palette with glassmorphism cards

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
- **Wrong sentences must be tricky** — silly/absurd wrongs (tacos, moon, unicorns) made it too easy to guess without knowing the word
- **Variety in wrong sentence types** — if all wrongs are just "opposite meaning," that's also a guessable pattern
- **Feedback overlay timing** — needs to be long enough to read (1.8s correct, 2.7s wrong) but not so long it kills momentum
- **Font size matters** — had to increase from initial design for readability
- **Hints must actually help** — Round 1 hints give partial definition, Round 2 gives first half of word + letter count, Round 3 gives full definition
- **Round selector** — lets parents/kids skip to harder rounds if they already know the basics

## User Preferences
- Parent is building this for their child
- Child likes K-pop (Stray Kids, Ateez specifically)
- Gen Z slang is preferred for all UI text and feedback
- Vocabulary comes from chapter-based book study (appears to be a novel)
- User wants to upload new vocab photos each week and have the game updated
- Game runs as a local HTML file (no server needed)
