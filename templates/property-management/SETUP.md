# Setup — New Property Management Project

## 3-Step Quickstart

### 1. Copy this template

```bash
cp -r ~/dotfiles/templates/property-management ~/projects/<property-name>
cd ~/projects/<property-name>
```

### 2. Initialize git

```bash
git init
git add .
git commit -m "Initialize property management project from template"
```

### 3. Fill in PROPERTY.md

Open `PROPERTY.md` and replace every `[placeholder]` with real values:
- Property address
- Current tenancy details
- Managing agent contact
- Utility account numbers
- Insurance policy details
- Key dates

Once PROPERTY.md is complete, start a Claude Code session. It will orient itself from the file automatically.

---

## First Session Checklist

After filling in PROPERTY.md:

- [ ] Upload key documents to appropriate folders (leases/, insurance/, property-docs/)
- [ ] Run organizer agent to file and name everything correctly
- [ ] Initialize TIMELINE.md with key historical events (purchase date, previous tenancies, major works)
- [ ] Populate status/ files with current state
- [ ] Set up first tax year folder: `mkdir -p tax/YYYY-YY/{income,expenses/{agent-fees,insurance,maintenance,utilities}}`
- [ ] Commit everything

---

## Project Template Contents

```
.claude/         — Agent instructions (generic, no property-specific content)
inbox/           — Drop new documents here; auto-processed at session start
insurance/       — Insurance policies and claims
expenses/        — Invoices, receipts, bills
  utilities/     — Utility bills (high volume)
leases/          — Tenancy agreements, inventories, references
certificates/    — Safety certificates (gas, electrical, EPC)
property-docs/   — Ownership documents, surveys, mortgage docs
status/          — Rolling current-state snapshots per domain
tax/             — Tax evidence by UK tax year
PROPERTY.md      — Fill this in first (all property-specific context)
ORGANIZATION.md  — Naming conventions and categorization rules
TIMELINE.md      — Append-only event log
TASKS.md         — Active to-do list
PROJECT.md       — Goals and plan
DESIGN.md        — Architecture decisions
organizer.log    — File operation history
.gitignore       — Excludes PDF/DOCX, keeps markdown
```
