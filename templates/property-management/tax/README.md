# Tax Evidence Folder

Organised by UK tax year (6 April – 5 April). Each year folder contains:
- `SUMMARY.md` — all declared income and expenses with amounts and file references
- `income/` — symlinks to rent statements and payment records
- `expenses/` — symlinks to deductible expense documents
  - `agent-fees/` — letting agent fees (management, tenant find, etc.)
  - `insurance/` — landlord insurance premiums
  - `maintenance/` — repair invoices, cleaning receipts, contractor costs
  - `utilities/` — utility costs paid by landlord (not tenant)

## How to Use

**For accountant submission:** Point your accountant to the relevant `YYYY-YY/` folder. SUMMARY.md lists everything with amounts. All supporting documents are one click away via symlinks.

**For self-assessment:** Use SUMMARY.md as your working document. It shows gross income, allowable expenses, and net taxable income.

**Adding documents mid-year:**
1. File the document in its permanent location (expenses/, insurance/, etc.) following normal naming conventions
2. Add a symlink in the relevant `tax/YYYY-YY/expenses/<category>/` folder:
   ```bash
   cd tax/YYYY-YY/expenses/<category>
   ln -sf "../../../../<permanent-path>/<filename>.pdf" "<filename>.pdf"
   ```
3. Update `tax/YYYY-YY/SUMMARY.md` with the new line item

**Tax year boundaries (UK):**
- 2024-25: 6 April 2024 – 5 April 2025
- 2025-26: 6 April 2025 – 5 April 2026 (SA return due 31 Jan 2027)
- 2026-27: 6 April 2026 – 5 April 2027 (SA return due 31 Jan 2028)

**NRL note:** As a Non-Resident Landlord, income is reported on UK Self Assessment. The NRL scheme means the letting agent does not withhold tax (from March 2026 onwards). Declare gross rental income and claim allowable expenses.

## Allowable Expenses (UK Landlord)

Expenses you can deduct from rental income for tax purposes:
- Letting agent fees (management fees, tenant find fees)
- Landlord insurance premiums
- Maintenance and repairs (not improvements)
- Utility costs paid by landlord (not recoverable from tenant)
- Professional fees (accountant, legal — for rental business)
- Ground rent and service charges (if paid by landlord)
- Mortgage interest (via Finance Cost Relief — 20% basic rate credit)

**Not allowable:** Capital improvements, personal costs, Help to Buy repayments.

## Symlinks vs Copies

This folder uses **symlinks** (not copies) to avoid duplicating files. The actual documents live in their permanent locations (expenses/, insurance/, etc.). If you need to send documents to an accountant, either:
1. Share the whole project folder and point them to `tax/YYYY-YY/`
2. Or run: `cp -LR tax/YYYY-YY/ ~/Desktop/tax-pack-YYYY-YY/` to create a flat copy with all symlinks resolved
