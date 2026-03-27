# Organization Guide

This document explains the folder structure and provides guidance for categorizing documents. Use this as reference when organizing files manually or when configuring the organizer agent.

## Folder Structure

```
<project-root>/
├── inbox/              # Drop new documents here — auto-processed at session start
├── insurance/          # Insurance policies, claims, correspondence
├── expenses/           # Receipts, invoices, bills, payments
│   └── utilities/      # Utility bills (electricity, gas, water, internet)
├── leases/             # Tenant agreements, contracts, terms, inventories
├── certificates/       # Gas safety, EPC, EICR, maintenance records
├── property-docs/      # Ownership docs, sale agreements, deeds, surveys
├── status/             # Rolling current-state snapshots (one file per domain)
└── tax/                # Tax evidence organised by tax year
```

---

## Categorization Rules

### insurance/
- Building/landlord insurance policies and schedules
- Contents insurance
- Liability insurance
- Claims documentation
- Renewal notices and invoices

### expenses/
- Receipts for repairs and maintenance
- Management fees, tenant find fees
- Professional fees (accountant, legal)
- Invoices from contractors

#### expenses/utilities/
- Utility bills (electricity, gas, water, internet, heating)
- Account closure notices
- High-volume recurring bills — kept separate from one-off expenses

### leases/
- Tenancy agreements (AST and other types)
- Management agreements
- Check-in and check-out inventories
- Deposit protection certificates
- Tenant references and screening reports

### certificates/
- Gas Safety Certificates (annual)
- Electrical Installation Condition Reports (EICR)
- Energy Performance Certificates (EPC)
- PAT testing records
- Boiler service records

### property-docs/
- Title deeds and land registry documents
- Sale agreements and completion statements
- Surveys
- Help to Buy / shared ownership documents
- Mortgage statements
- Planning permissions

### status/
See ORGANIZATION.md status/ section.

### tax/
See ORGANIZATION.md tax/ section and tax/README.md.

---

## Naming Conventions

### Bills / Statements with a service period
**Format:** `{provider}-{YYYY-MM-DD}-to-{YYYY-MM-DD}.pdf`

Examples:
- `hyperoptic-2026-01-18-to-2026-02-17.pdf`
- `british-gas-2025-09-06-to-2025-12-06.pdf`
- `thames-water-2025-07-03-to-2025-12-31.pdf`

### Single-date documents
**Format:** `{category}-{description}-{YYYY-MM-DD}.pdf`

Examples:
- `lease-ast-tenant-2026-01-15-to-2027-01-14.pdf`
- `inventory-checkin-2026-01-15.pdf`
- `gas-safety-cert-2025-10-01.pdf`
- `invoice-plumber-2025-08-12.pdf`

### General rules
- Lowercase with hyphens (kebab-case)
- Full ISO dates (YYYY-MM-DD) always
- No spaces in filenames
- Be descriptive but concise

---

## Edge Cases

| Document Type | Folder | Rationale |
|---|---|---|
| Contractor quote | `expenses/` | Future expense — keep with invoices |
| Tenant maintenance request | `certificates/` or `expenses/` | Compliance issue → certificates; led to work → expenses |
| Property tax demand | `expenses/` | Recurring cost |
| Letting agent statement | `expenses/` | Shows rent collected and fees |
| Solicitor correspondence (sale) | `property-docs/` | Related to ownership |
| Tenant reference report | `leases/` | Part of tenancy process |
| Insurance claim for repair | `insurance/claims/` | Primary purpose: claim |

---

## status/ — Rolling Current-State Files

Each `status/` file covers one domain. Newest state at the top.

**Update pattern:**
1. Read the existing `## Current State` section
2. Write a NEW `## Current State — YYYY-MM-DD` section with all still-relevant info + updates/corrections
3. Rename the previous current state to `## Previous State — YYYY-MM-DD`
4. Older entries remain untouched

---

## tax/ — Tax Evidence

Organised by UK tax year (6 April – 5 April). Each year folder has:
- `SUMMARY.md` — income and expense totals for HMRC SA
- `income/` — symlinks to rent statements
- `expenses/{category}/` — symlinks to deductible documents

See `tax/README.md` for full instructions.

---

## When to Update This Document

Add entries here when:
- A new document type appears that doesn't fit existing categories
- You make a categorization decision that should be standardized
- You add subdirectories or change the structure
- You want to document a naming convention decision
