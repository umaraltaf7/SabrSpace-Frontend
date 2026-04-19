# Self Page Implementation Guide

## Goal

Create a new **Self** page that opens when the user taps the profile entry point from Home/shell navigation.  
The page should feel native to the current Sabr Space aesthetic (lavender + midnight gradients, rounded cards, soft glows) and include:

- Mood meter
- Streaks
- Personalization actions and settings

---

## Current App Wiring (What Already Exists)

- Routing lives in `lib/core/router/app_router.dart` using `go_router`.
- The bottom nav "Profile" tab currently points to `'/profile'`.
- `ProfileScreen` exists at:
  `lib/features/profile/presentation/screens/profile_screen/profile_screen.dart`
- Shared semantic theme access is available through:
  - `context.palette` from `lib/core/theme/theme_palette.dart`
  - `AppTypography` from `lib/core/theme/app_typography.dart`
  - spacing constants from `lib/core/constants/app_spacing.dart`

---

## Recommended Approach

Use a **new route + new screen** for the Self page and keep `ProfileScreen` as an account/settings detail page.

### Why

- Self page becomes a personalized dashboard (mood, streaks, quick actions).
- Existing `ProfileScreen` already behaves like account/settings and can still be linked from Self.
- Cleaner IA: "Self" (daily personal hub) vs "Profile" (account/preferences).

---

## File Plan

1. Add new screen:
   - `lib/features/profile/presentation/screens/self_screen/self_screen.dart`

2. Register route:
   - `lib/core/router/app_router.dart`
   - add `GoRoute(path: '/self', builder: ... )`

3. Update shell nav + selection mapping:
   - `lib/core/router/app_router.dart`
   - change nav item label/route from `Profile -> /profile` to `Self -> /self`
   - update `_selectedShellIndex` so `'/self'` is selected at index 3

4. Keep drawer item options:
   - Option A (recommended): add both `Self` and `Profile` in drawer
   - Option B: replace drawer `Profile` path with `'/self'` and access account settings from Self

5. Optional entry from Home header:
   - In `lib/features/home/presentation/screens/home_screen/home_screen.dart`
   - if this is the intended profile button, route tap to `'/self'`

---

## UI Structure for `SelfScreen`

Use this vertical structure:

1. **Header card**
   - User avatar + name
   - "How are you feeling today?" CTA to mood check (`/mood-check`)

2. **Mood Meter card**
   - Current mood state
   - Last check-in timestamp
   - Action: "Update Mood" -> `/mood-check`

3. **Streaks card**
   - Main streak count (e.g., check-in streak)
   - Secondary mini stats (journal streak, dhikr streak)
   - Action: "View details" -> `/streak`

4. **Personalize section**
   - Theme mode quick toggle (reuse existing provider pattern from `ProfileScreen`)
   - Quick links:
     - Journal (`/journal`)
     - Audio (`/audio-library`)
     - Milestones (`/milestone`)
     - Support (`/support`)

5. **Account section**
   - Button: "Account & Settings" -> `/profile`

---

## Theme + Color Consistency Rules

To stay aligned with current app style:

1. Use semantic colors (preferred)
   - `context.palette.surface`
   - `context.palette.primary`
   - `context.palette.onSurface`
   - `context.palette.onSurfaceVariant`
   - `context.palette.etherealGradientStart`
   - `context.palette.etherealGradientEnd`

2. Use spacing tokens only
   - `AppSpacing.sm`, `md`, `lg`, `xl`, etc.

3. Use existing typography helpers
   - `AppTypography.headlineSmall(context)`
   - `AppTypography.titleMedium(context)`
   - `AppTypography.bodyMedium(context)`

4. Card treatment
   - Radius: `20-28`
   - Border with low opacity
   - Soft shadow with medium blur
   - Gradient backgrounds for hero/important cards

5. Light/Dark parity
   - Design each card to support both brightness modes
   - Verify contrast for all label/value text

---

## Suggested Data Contract (MVP)

For initial implementation, keep values local/mock so UI can ship first:

- `moodLabel`: string (`"Calm"`, `"Anxious"`, etc.)
- `moodUpdatedAt`: DateTime
- `checkInStreakDays`: int
- `journalStreakDays`: int
- `dhikrStreakDays`: int
- `displayName`: string

Later, move to providers/repositories.

---

## Navigation Mapping (Target Behavior)

- Bottom nav "Self" tap -> `'/self'`
- Home profile entry point tap -> `'/self'`
- Mood meter action -> `'/mood-check'`
- Streak action -> `'/streak'`
- Account settings action -> `'/profile'`

---

## Implementation Checklist

- [ ] Create `SelfScreen` scaffold with gradient background + scroll body
- [ ] Build reusable card widget for Self page sections
- [ ] Add mood meter card + action
- [ ] Add streak card + stats row + action
- [ ] Add personalization quick actions
- [ ] Add account/settings entry button to existing Profile page
- [ ] Register `'/self'` route in router
- [ ] Update shell nav label/route and selected index logic
- [ ] Validate light and dark themes manually
- [ ] Ensure responsive layout for small screens

---

## QA / Acceptance Criteria

- Tapping profile/self entry from Home shell opens Self page consistently.
- Self page uses the same color family, depth, and typography as existing Home/Profile screens.
- Mood meter and streak cards are visible above the fold on common phone sizes.
- Theme toggle works and state persists exactly as it does in `ProfileScreen`.
- No navigation regressions for `/profile`, `/streak`, `/mood-check`.

---

## Notes for Incremental Delivery

If you want faster rollout, split into phases:

1. **Phase 1:** Route + basic Self page shell + placeholder cards
2. **Phase 2:** Mood/streak data wiring and polish
3. **Phase 3:** Personalization depth (goals, reminders, recommendations)
