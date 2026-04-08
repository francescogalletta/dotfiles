---
name: slides
description: Generate editable PPTX presentations from a topic or brief. Trigger when the user wants to create a slide deck, presentation, or pitch — even casually ("I need slides for X", "make a deck about Y", "presentation for the team").
user-invocable: true
allowed-tools: Bash(uv:*), Bash(open:*), Bash(cat:*)
---

# /slides

Generate a branded Monzo PPTX deck that the team can edit in PowerPoint or Google Slides.

## Phase 1 — Brief

Ask the user (one message, not a checklist):
- What is this presentation about?
- Who is the audience?
- How many slides (rough range is fine)?
- Any specific data, metrics, or topics to include?

If the user already provided enough context in their invocation, skip straight to Phase 2.

## Phase 2 — Draft

Generate a JSON content structure following this schema:

```json
{
  "metadata": {
    "title": "Deck Title",
    "subtitle": "Optional subtitle",
    "author": "Author name",
    "date": "YYYY-MM-DD"
  },
  "slides": [
    {"layout": "title", "title": "...", "subtitle": "...", "notes": "..."},
    {"layout": "section", "title": "Section Name"},
    {"layout": "content", "title": "...", "body": ["bullet 1", "bullet 2"], "notes": "..."},
    {"layout": "two_column", "title": "...", "left": {"heading": "...", "body": [...]}, "right": {"heading": "...", "body": [...]}, "notes": "..."},
    {"layout": "three_column", "title": "...", "columns": [{"heading": "...", "body": [...]}], "notes": "..."},
    {"layout": "four_column", "title": "...", "columns": [{"heading": "...", "body": [...]}], "notes": "..."},
    {"layout": "blank", "notes": "Insert image here"},
    {"layout": "closing", "title": "Questions?", "subtitle": "email"}
  ]
}
```

**Available layouts:** `title`, `section`, `content`, `two_column`, `three_column`, `four_column`, `blank`, `closing`

**Available themes:** `light` (white bg, navy hero — default), `dark` (navy bg, coral hero), `default` (white bg, coral hero/sections)

Set via `"theme": "dark"` in metadata, or `--theme dark` on the CLI.

**Guidelines for content generation:**
- Start with a `title` slide, end with `closing`
- Use `section` slides to divide major topics
- Keep bullets concise (< 10 words each)
- Use `four_column` for KPIs/metrics
- Use `two_column` for before/after or comparisons
- Add speaker notes for key talking points
- 8–15 slides is typical for a team update; adjust to context

**Do NOT write any files yet.** Present the outline in human-readable format:

```
Deck: <title> (<N> slides)

1. [TITLE] Title — Subtitle
2. [SECTION] Section Name
3. [CONTENT] Slide Title (N bullets)
4. [TWO-COL] Comparison Title
...

Theme: light | dark | default
Speaker notes: included on N slides

Change anything, or generate?
```

**Wait for confirmation.** Iterate if the user requests changes.

## Phase 3 — Generate

On confirmation:

1. Write the JSON to a temp file:
   ```
   cat > /tmp/slides-deck.json << 'EOFJSON'
   <the JSON content>
   EOFJSON
   ```

2. Run the generator:
   ```
   uv run --project ~/projects/slides-generator python ~/projects/slides-generator/generate.py --input /tmp/slides-deck.json --output ./<slug>.pptx
   ```
   Use a slugified version of the title for the filename (e.g., `q1-fincrime-ae-review.pptx`).

3. Open the file:
   ```
   open ./<slug>.pptx
   ```

## Phase 4 — Done

Print:

```
Generated: ./<slug>.pptx (<N> slides)

Opened in your default app. Edit freely — all text is editable.

To regenerate with changes, just tell me what to update.
```
