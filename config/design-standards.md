# Design standards

The primary UI design skill is **Taste Skill**. Use one design system at a time.
Do not enable UI UX Pro Max and Taste Skill on the same task by default.

## Before designing

- Read `docs/PRODUCT.md` and the feature requirements.
- Identify the audience, the one job the screen must do, and the existing design
  system or tokens.
- Reuse the project's components and semantic tokens. Add missing tokens rather
  than creating a parallel theme.
- Decide the visual direction explicitly (references, typography, colour,
  density, motion). "Clean and modern" is not a direction.

## Quality bar

- **Hierarchy**: one clear primary action per view; scanning order is obvious.
- **Typography**: intentional scale and measure; no default browser styling.
- **Colour**: semantic tokens, sufficient contrast, and a restrained palette.
- **Spacing**: consistent scale; avoid arbitrary one-off values.
- **States**: hover, focus-visible, active, disabled, loading, empty, error, and
  success are all designed.
- **Responsive**: verify at a narrow mobile width and a wide desktop width.
- **Accessibility**: keyboard reachable, visible focus, semantic landmarks,
  labelled controls, no colour-only meaning.
- **Content**: real labels and realistic data, not lorem ipsum, in the final
  review.
- **Motion**: purposeful and reduced-motion safe.

## Verification

- Run the project's build and browser checks.
- Inspect the page in a real browser at desktop and mobile widths.
- Check contrast, focus order, and the console for errors.
- Capture the final state or describe exactly what was inspected.
- Report what was not verified (for example Safari, screen reader, dark mode).

## Anti-patterns

- Generic purple-gradient SaaS styling applied without a brief.
- Decorative gradients, glows, and blobs that do not serve hierarchy.
- Icon-only controls without accessible names.
- Hover-only affordances.
- Layouts that break below 360 px.
- Hard-coded colours that bypass the token system.
