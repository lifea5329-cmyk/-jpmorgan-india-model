# JPMorgan India: Mumbai (Powai) GCC Campus - Financial Analysis

Educational portfolio project. It asks one question: can JPMorgan's planned global capability centre (GCC) campus in Powai, Mumbai add profit, and how could it lead to a loss? It uses Excel and SQL, built on JPMorgan's past financial performance in Asia-Pacific and India. Not investment advice.

## Files

| File | What it is |
| --- | --- |
| `JPMorgan_India_Mumbai_GCC_Financial_Report.pdf` | 8-page report: past performance, how the project can raise profit, how it can lead to a loss, scenarios, break-even points |
| `jpmorgan_india_model.xlsx` | Excel model with live formulas: Read Me, Summary, Hist_Data, Assumptions, Model_Base, Model_Best, Model_Stress, Sensitivity, SQL_Results |
| `jpmorgan_india_analysis.sql` | Creates six tables, loads the data and runs eight analysis queries (MySQL 8.0+; also runs on SQLite 3.35+) |

## Headline results (INR crore unless stated, 10% discount rate, 2026-2038)

| | Base | Best case | Stress case |
| --- | --- | --- | --- |
| Net present value | 2,895 | 13,290 | (3,962) |
| Net present value (USD million) | 305 | 1,399 | (417) |
| Cash payback year | 2032 | 2030 | Not by 2038 |

Break-even points for the base case (one input changed at a time): seat occupancy 49% (base assumes 85%), share of new or moved roles 20% (base 35%), cost of the same role elsewhere vs India 1.54x (base 1.8x).

## How the model works

- **Savings:** cost avoided by staffing new or moved roles in India instead of higher-cost locations.
- **Costs:** Powai rent (about 13 lakh sq ft at Rs 300 per sq ft a month, rising 4.5% a year), running costs, fit-out and a refundable deposit.
- **Scenarios:** base, best and stress cases differ in occupancy, AI effect on headcount, share of new or moved roles, cost gap, wage inflation, rupee and fit-out cost. All levers are on the `Assumptions` sheet.

## Running the SQL

In MySQL Workbench: open `jpmorgan_india_analysis.sql` and use Execute script. Each query's result opens in its own tab. The net present values in Q4 match the Excel `Summary` sheet.

## Sources

- [JPMorgan Chase 2025 MD&A three-year summary](https://www.jpmorganchase.com/content/dam/jpmc/jpmorgan-chase-and-co/investor-relations/documents/managements-discussion-analysis-2025.pdf)
- [Tofler: J.P. Morgan Services India](https://www.tofler.in/j-p-morgan-services-india-private-limited/company/U72900MH2000PTC124073)
- [J.P. Morgan Securities India Boards' Report FY2024-25](https://www.jpmorgan.com/content/dam/jpm/global/disclosures/us/jpmsi-boards-report-for-fy-2024-25-final.pdf)
- [Realty Today: Powai lease details](https://therealtytoday.com/news/commercial/jp-morgans-powai-lease-becomes-one-of-indias-biggest-single-tenant-office-deals)
- [Realty Today: Brookfield commitment](https://therealtytoday.com/news/commercial/asias-largest-gcc-planned-in-mumbai-as-brookfield-commits-9000-crore/)
- [People Matters: Mumbai GCC plan](https://www.peoplematters.in/news/business/jpmorgan-plans-asias-largest-gcc-in-mumbai-with-30000-employees-47772)
- [Outlook Business, 21 Sep 2026](https://www.outlookbusiness.com/corporate/the-banker-and-the-boom-why-jamie-dimon-is-in-mumbai-this-week)
- [Outlook Business, 23 Jul 2026](https://www.outlookbusiness.com/corporate/jpmorgan-to-add-1000-tech-roles-at-india-gcc-despite-ai-driven-workforce-gains)
- [Business Standard, 3 Sep 2025](https://www.business-standard.com/companies/news/jpmorgan-to-boost-corporate-banking-presence-in-india-on-investment-jump-125090300110_1.html)
- [IBEF, 24 Sep 2026](https://www.ibef.org/news/jpmorgan-to-double-gift-city-business-as-us-1-billion-book-expands)

## Limits

- The scenario inputs are illustrative assumptions, not JPMorgan figures. JPMorgan has not published a business case for this campus.
- India GCC history comes from Tofler, a site that compiles company filings, not from audited accounts.
- Only the 13 lakh sq ft lease is costed. Rent saved by vacating other offices, productivity, retention, new revenue, tax and transfer pricing are not modelled.
- The Brookfield article does not name JPMorgan; it is linked to this campus by location, size and timing.
- The rupee rate (Rs 95 per US dollar) is derived from a conversion in an Outlook Business article and held flat.
