---
name: explain
description: Educational mode — explains code, diffs, or concepts in plain language with trade-offs and what to learn next. Use when the user asks "explain this", "what does X do", "why did we choose Y", or runs /explain. Also useful when returning to a project after time away.
user-invocable: true
---

# /explain

Educational mode. Takes a diff, file, or concept name and explains it clearly.

## Input

The user can pass:
- A file path → explain what it does and why it's structured that way
- A concept or term → explain it in plain language with context to the current project
- Nothing → if in a project directory, read `git diff HEAD~1` and explain the most recent change

## What to produce

### 1. What it does

Plain-language explanation. No jargon unless defined. Use analogies if helpful. Max 3 paragraphs.

### 2. Why this approach

- What problem does this solve?
- What alternatives were considered (or are common)?

### 3. Trade-off table

Always include:

| Option | Pros | Cons | Best when |
|--------|------|------|-----------|

Include the chosen approach and at least one alternative.

### 4. What to learn next

3–5 bullet points pointing to the next concepts, patterns, or docs worth exploring if the user wants to go deeper. Be specific (link to docs sections, name specific patterns, etc.) but keep it optional — not required reading.

## Tone

- Assume the reader is smart but unfamiliar with this specific thing
- Lead with the concrete before the abstract
- Code snippets are fine when they clarify — keep them short
- Don't pad. If it can be said in one sentence, say it in one sentence.
