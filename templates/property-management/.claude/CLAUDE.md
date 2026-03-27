# Property Management — Project Instructions

This is a property management system using agent-based document organisation and information extraction. All property-specific details (address, tenant, contacts, accounts) are in `PROPERTY.md` — read that file for context.

## Session Start

Every time you start a session in this project, follow this order:

1. **Check `inbox/` first** — see INBOX AUTO-PROCESS rule below
2. Read `PROPERTY.md` — all property-specific context
3. Read `PROJECT.md` — current state, tasks, and plan
4. Read `DESIGN.md` — architecture decisions
5. Read `TIMELINE.md` (last 10 entries) — recent property events
6. Read `status/` files — current state snapshots for each domain
7. Run `git log --oneline -10` — recent activity

## INBOX AUTO-PROCESS (mandatory — run before anything else)

At the very start of every session, before the briefing:

1. Run `ls inbox/ 2>/dev/null` to check for files
2. If inbox contains ANY files:
   - Immediately spawn analysis subagents (no need to ask first)
   - Group files by category; use 1–5 agents depending on count (see organizer.md for grouping logic)
   - Each agent reads its assigned documents, extracts key info, and proposes file moves with correct naming
   - Collect all proposals and present ONE consolidated filing proposal to the user
   - Wait for approval, then execute all moves and log them to `organizer.log`
3. Only after inbox is empty: proceed with standard session briefing

This is non-negotiable. Do not skip this step or defer it.

## Rules

- Follow the global `~/CLAUDE.md` as baseline — this file adds project-specific rules
- Read `PROPERTY.md` for all property-specific context — never hardcode addresses, names, or numbers
- Update `PROJECT.md` when the plan changes or tasks are completed
- Add entries to `DESIGN.md` when making architecture or design decisions
- **NEVER delete or move files without explicit user approval**
- All file operations by organiser agent must be logged to `organizer.log`
- Commit frequently with clear messages

## Status File Maintenance

After any agent operation that changes property state (new documents filed, events occur, tasks completed):

- Offer to update the relevant `status/` file using the **prepend-current-state** pattern:
  1. Read the existing `Current State` section
  2. Write a NEW `## Current State — YYYY-MM-DD` section at the top with all still-relevant info plus any updates
  3. Rename the old current state to `## Previous State — YYYY-MM-DD`
  4. Older states remain below for reference
- Do not edit entries below the current state — they are the historical record

**Which file to update:**
- New/changed utility accounts → `status/utilities.md`
- Tenancy changes (rent, tenant, dates) → `status/tenancy.md`
- Insurance changes → `status/insurance.md`
- Financial figures updated → `status/finances.md`
- Compliance certificates / safety docs → `status/compliance.md`

## Agent Invocation

This project uses specialised agents. To invoke:

- **Organiser:** Direct invocation following `.claude/organizer.md` instructions
  - Read organizer.md before starting
  - Follow the 6-step workflow: Scan → Analyse → Propose → Approve → Execute → Log
  - Always extract service period dates from bills/statements
  - Use naming convention: `{provider}-{YYYY-MM-DD}-to-{YYYY-MM-DD}.pdf` for bills
- **Summariser:** Direct invocation + read `.claude/summarizer.md`
  - Only processes NEW files since last run (checks organizer.log timestamp)
  - Builds timeline entries from document contents
  - After running, offer to update relevant status/ files
- **Task Manager:** Direct invocation + read `.claude/task-manager.md`
  - Maintains TASKS.md based on timeline events and user input
  - Prioritises urgent items (financial, compliance, safety)
  - Run after summariser or when user adds new tasks
- **Extractor:** Direct invocation + read `.claude/extractor.md`
- **Writer:** Direct invocation + read `.claude/writer.md`
- **Accountant:** Direct invocation + read `.claude/accountant.md`
  - Also maintains `tax/` folder and SUMMARY.md files

See `README.md` for detailed usage examples.

## File Structure

```
<project-root>/
├── .claude/              # Agent instructions
│   ├── CLAUDE.md         # This file — project rules (generic)
│   ├── organizer.md      # Document organisation agent
│   ├── summarizer.md     # Timeline builder agent
│   ├── task-manager.md   # Task list curator agent
│   ├── extractor.md      # Information extraction agent
│   ├── writer.md         # Response writer agent
│   └── accountant.md     # Financial analysis + tax evidence agent
├── inbox/                # Drop new documents here — auto-processed at session start
├── insurance/            # Insurance policies, claims
├── expenses/             # Receipts, invoices, bills, service charges
│   └── utilities/        # Utility bills (electricity, gas, water, internet)
├── leases/               # Tenant agreements, contracts, inventories
├── certificates/         # Maintenance certs, safety docs
├── property-docs/        # Ownership, sale docs, deeds, tax forms
├── status/               # Rolling current-state snapshots (one file per domain)
│   ├── tenancy.md        # Current tenant, rent, deposit, key dates
│   ├── insurance.md      # Active policy, coverage, renewal
│   ├── utilities.md      # Current providers, accounts, status
│   ├── finances.md       # Income/expense summary, Help to Buy, fees
│   └── compliance.md     # Certificates, legal requirements, due dates
├── tax/                  # Tax evidence organised by tax year
│   ├── README.md         # How to use the tax folder
│   ├── YYYY-YY/          # One folder per tax year (e.g. 2025-26)
│   │   ├── SUMMARY.md    # All declared items with amounts and file refs
│   │   ├── income/       # Symlinks to rent statements
│   │   └── expenses/     # Symlinks to deductible expense docs
├── PROPERTY.md           # All property-specific context (read this first)
├── ORGANIZATION.md       # Folder structure rationale + naming conventions
├── TIMELINE.md           # Chronological event log (append-only)
├── TASKS.md              # Active to-do list
├── PROJECT.md            # Goals, plan, decisions
├── DESIGN.md             # Architecture decision records
└── organizer.log         # Log of all file operations
```

## Safety Constraints

**For Organiser Agent:**
- Read-only analysis first
- Propose moves in structured format
- Wait for user approval
- Log all operations to `organizer.log`
- Never delete files
- Create backups before moving if unsure

**For All Agents:**
- No external API calls
- No deletion of original documents
- Read `PROPERTY.md` for all property-specific details — never hardcode
- Preserve file metadata when possible
- Reference source files when extracting information
