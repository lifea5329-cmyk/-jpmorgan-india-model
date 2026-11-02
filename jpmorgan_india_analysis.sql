-- JPMorgan India: Mumbai (Powai) GCC campus - SQL analysis
-- Data: JPMorgan 2025 MD&A, Tofler, J.P. Morgan Securities India Boards' Report; scenario cash flows
--       come from the Excel model (jpmorgan_india_model.xlsx). INR crore unless stated.
-- Engine: written for MySQL 8.0+ (window functions, POWER); also runs on SQLite 3.35+.

DROP TABLE IF EXISTS jpm_firm;
DROP TABLE IF EXISTS jpm_apac;
DROP TABLE IF EXISTS gcc_india;
DROP TABLE IF EXISTS jpmsi_nbfc;
DROP TABLE IF EXISTS scenario_params;
DROP TABLE IF EXISTS scenario_cashflows;

CREATE TABLE jpm_firm (
  year INTEGER PRIMARY KEY,
  net_revenue_usd_m DOUBLE, nonint_expense_usd_m DOUBLE, net_income_usd_m DOUBLE, headcount INTEGER);
CREATE TABLE jpm_apac (
  year INTEGER PRIMARY KEY,
  apac_net_revenue_usd_m DOUBLE, intl_net_revenue_usd_m DOUBLE);
CREATE TABLE gcc_india (            -- J.P. Morgan Services India Pvt Ltd, INR crore
  fy INTEGER PRIMARY KEY,
  revenue_cr DOUBLE, net_profit_cr DOUBLE, employee_cost_cr DOUBLE, net_worth_cr DOUBLE);
CREATE TABLE jpmsi_nbfc (           -- J.P. Morgan Securities India Pvt Ltd, INR crore
  fy INTEGER PRIMARY KEY,
  total_revenue_cr DOUBLE, pbt_cr DOUBLE, pat_cr DOUBLE);
CREATE TABLE scenario_params (
  scenario VARCHAR(20) PRIMARY KEY, discount_rate DOUBLE, fx_inr_per_usd DOUBLE, base_year INTEGER);
CREATE TABLE scenario_cashflows (   -- INR crore; costs are negative
  scenario VARCHAR(20), year INTEGER, heads DOUBLE, gross_savings_cr DOUBLE, rent_cr DOUBLE, opex_cr DOUBLE,
  depreciation_cr DOUBLE, net_accounting_cr DOUBLE, capex_cr DOUBLE, deposit_cr DOUBLE, stamp_cr DOUBLE,
  net_cash_cr DOUBLE,
  PRIMARY KEY (scenario, year));

-- ---------- data ----------
INSERT INTO jpm_firm VALUES
  (2023, 158104, 87172, 49552, 309926),
  (2024, 177556, 91797, 58471, 317233),
  (2025, 182447, 95640, 57048, 318512);
INSERT INTO jpm_apac VALUES
  (2023, 7891, 24470),
  (2024, 8867, 26485),
  (2025, 10699, 30524);
INSERT INTO gcc_india VALUES
  (2021, 11407.1, 1151, 8151.8, 10788.4),
  (2022, 14101.8, 1305.5, 10195.2, 12182.5),
  (2023, 18379.8, 1965.1, 13006.7, 14015.1),
  (2024, 21469.7, 1997.5, 15859, 16132.6),
  (2025, 24923.5, 2581.9, 18344.1, 18596);
INSERT INTO jpmsi_nbfc VALUES
  (2024, 357.09, 319.09, 236.82),
  (2025, 405.42, 358.79, 265.19);
INSERT INTO scenario_params VALUES
  ('Base', 0.1, 95, 2025),
  ('Best case', 0.1, 95, 2025),
  ('Stress case', 0.1, 95, 2025);
INSERT INTO scenario_cashflows VALUES
  ('Base', 2026, 0, 0, 0, 0, 0, 0, 0, -468, -125, -593),
  ('Base', 2027, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
  ('Base', 2028, 0, 0, 0, 0, 0, 0, -292.5, 0, 0, -292.5),
  ('Base', 2029, 4475.25, 480.3551, -468, -117, -83.5714, -188.2163, -292.5, 0, 0, -397.1449),
  ('Base', 2030, 8950.5, 992.0075, -489.06, -122.265, -83.5714, 297.111, 0, 0, 0, 380.6825),
  ('Base', 2031, 12679.875, 1449.2996, -511.0677, -127.7669, -83.5714, 726.8936, 0, 0, 0, 810.465),
  ('Base', 2032, 14917.5, 1756.0042, -534.0657, -133.5164, -83.5714, 1004.8506, 0, 0, 0, 1088.422),
  ('Base', 2033, 14917.5, 1805.8234, -558.0987, -139.5247, -83.5714, 1024.6285, 0, 0, 0, 1108.2),
  ('Base', 2034, 14917.5, 1854.1091, -583.2131, -145.8033, -83.5714, 1041.5212, 0, 0, 0, 1125.0926),
  ('Base', 2035, 14917.5, 1900.4027, -609.4577, -152.3644, -83.5714, 1055.0091, 0, 0, 0, 1138.5805),
  ('Base', 2036, 14917.5, 1944.1884, -636.8833, -159.2208, 0, 1148.0842, 0, 0, 0, 1148.0842),
  ('Base', 2037, 14917.5, 1984.8874, -665.5431, -166.3858, 0, 1152.9586, 0, 0, 0, 1152.9586),
  ('Base', 2038, 14917.5, 2021.8518, -695.4925, -173.8731, 0, 1152.4861, 0, 468, 0, 1620.4861),
  ('Best case', 2026, 0, 0, 0, 0, 0, 0, 0, -468, -125, -593),
  ('Best case', 2027, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
  ('Best case', 2028, 0, 0, 0, 0, 0, 0, -273, 0, 0, -273),
  ('Best case', 2029, 5112.9, 1056.5209, -468, -117, -78, 393.5209, -273, 0, 0, 198.5209),
  ('Best case', 2030, 10225.8, 2234.264, -489.06, -122.265, -78, 1544.939, 0, 0, 0, 1622.939),
  ('Best case', 2031, 14486.55, 3346.3325, -511.0677, -127.7669, -78, 2629.4979, 0, 0, 0, 2707.4979),
  ('Best case', 2032, 17043, 4161.5597, -534.0657, -133.5164, -78, 3415.9775, 0, 0, 0, 3493.9775),
  ('Best case', 2033, 17043, 4398.449, -558.0987, -139.5247, -78, 3622.8256, 0, 0, 0, 3700.8256),
  ('Best case', 2034, 17043, 4648.1362, -583.2131, -145.8033, -78, 3841.1197, 0, 0, 0, 3919.1197),
  ('Best case', 2035, 17043, 4911.2529, -609.4577, -152.3644, -78, 4071.4308, 0, 0, 0, 4149.4308),
  ('Best case', 2036, 17043, 5188.4566, -636.8833, -159.2208, 0, 4392.3525, 0, 0, 0, 4392.3525),
  ('Best case', 2037, 17043, 5480.4308, -665.5431, -166.3858, 0, 4648.5019, 0, 0, 0, 4648.5019),
  ('Best case', 2038, 17043, 5787.8856, -695.4925, -173.8731, 0, 4918.5199, 0, 468, 0, 5386.5199),
  ('Stress case', 2026, 0, 0, 0, 0, 0, 0, 0, -468, -125, -593),
  ('Stress case', 2027, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
  ('Stress case', 2028, 0, 0, 0, 0, 0, 0, -357.5, 0, 0, -357.5),
  ('Stress case', 2029, 2632.5, 54.3848, -468, -117, -102.1429, -632.7581, -357.5, 0, 0, -888.1152),
  ('Stress case', 2030, 5265, 85.3099, -489.06, -122.265, -102.1429, -628.158, 0, 0, 0, -526.0151),
  ('Stress case', 2031, 7458.75, 82.9815, -511.0677, -127.7669, -102.1429, -657.996, 0, 0, 0, -555.8531),
  ('Stress case', 2032, 8775, 47.0498, -534.0657, -133.5164, -102.1429, -722.6753, 0, 0, 0, -620.5324),
  ('Stress case', 2033, 8775, 0, -558.0987, -139.5247, -102.1429, -799.7662, 0, 0, 0, -697.6234),
  ('Stress case', 2034, 8775, 0, -583.2131, -145.8033, -102.1429, -831.1593, 0, 0, 0, -729.0164),
  ('Stress case', 2035, 8775, 0, -609.4577, -152.3644, -102.1429, -863.965, 0, 0, 0, -761.8222),
  ('Stress case', 2036, 8775, 0, -636.8833, -159.2208, 0, -796.1042, 0, 0, 0, -796.1042),
  ('Stress case', 2037, 8775, 0, -665.5431, -166.3858, 0, -831.9289, 0, 0, 0, -831.9289),
  ('Stress case', 2038, 8775, 0, -695.4925, -173.8731, 0, -869.3657, 0, 468, 0, -401.3657);

-- ---------- analysis queries ----------

-- Q1. Asia-Pacific revenue trend and share of the firm
SELECT a.year,
       a.apac_net_revenue_usd_m                                              AS apac_revenue_usd_m,
       ROUND(100.0 * (a.apac_net_revenue_usd_m * 1.0
             / LAG(a.apac_net_revenue_usd_m) OVER (ORDER BY a.year) - 1), 1) AS growth_pct,
       ROUND(100.0 * a.apac_net_revenue_usd_m / f.net_revenue_usd_m, 2)      AS share_of_firm_pct,
       ROUND(100.0 * a.apac_net_revenue_usd_m / a.intl_net_revenue_usd_m, 1) AS share_of_international_pct
FROM jpm_apac a JOIN jpm_firm f USING (year)
ORDER BY a.year;

-- Q2. India GCC (J.P. Morgan Services India) trend
SELECT fy,
       revenue_cr,
       ROUND(100.0 * (revenue_cr / LAG(revenue_cr) OVER (ORDER BY fy) - 1), 1) AS revenue_growth_pct,
       ROUND(100.0 * net_profit_cr / revenue_cr, 1)                            AS net_margin_pct,
       ROUND(100.0 * employee_cost_cr / revenue_cr, 1)                         AS staff_cost_pct_of_revenue,
       ROUND(100.0 * net_profit_cr / net_worth_cr, 1)                          AS return_on_net_worth_pct
FROM gcc_india
ORDER BY fy;

-- Q3. Five-year growth rates (CAGR) of the India GCC
SELECT ROUND(100.0 * (POWER(l.revenue_cr    / f.revenue_cr,    1.0 / (l.fy - f.fy)) - 1), 1) AS revenue_cagr_pct,
       ROUND(100.0 * (POWER(l.net_profit_cr / f.net_profit_cr, 1.0 / (l.fy - f.fy)) - 1), 1) AS net_profit_cagr_pct,
       ROUND(100.0 * (POWER(l.employee_cost_cr / f.employee_cost_cr, 1.0 / (l.fy - f.fy)) - 1), 1) AS staff_cost_cagr_pct
FROM gcc_india f, gcc_india l
WHERE f.fy = (SELECT MIN(fy) FROM gcc_india) AND l.fy = (SELECT MAX(fy) FROM gcc_india);

-- Q4. Campus value by scenario (net present value)
SELECT c.scenario,
       ROUND(SUM(c.net_cash_cr / POWER(1 + p.discount_rate, c.year - p.base_year)), 0)                        AS npv_inr_crore,
       ROUND(SUM(c.net_cash_cr / POWER(1 + p.discount_rate, c.year - p.base_year)) * 10 / p.fx_inr_per_usd, 0) AS npv_usd_million
FROM scenario_cashflows c JOIN scenario_params p ON p.scenario = c.scenario
GROUP BY c.scenario, p.fx_inr_per_usd
ORDER BY npv_inr_crore DESC;

-- Q5. Payback, deepest cash hole and loss years
WITH cum AS (
  SELECT scenario, year, net_cash_cr, net_accounting_cr, heads,
         SUM(net_cash_cr) OVER (PARTITION BY scenario ORDER BY year) AS cum_cash_cr
  FROM scenario_cashflows)
SELECT scenario,
       MIN(CASE WHEN cum_cash_cr >= 0 THEN year END)                  AS payback_year,
       ROUND(MIN(cum_cash_cr), 0)                                     AS deepest_cumulative_cash_cr,
       SUM(CASE WHEN heads > 0 AND net_accounting_cr < 0 THEN 1 ELSE 0 END) AS loss_years
FROM cum
GROUP BY scenario
ORDER BY scenario;

-- Q6. Do savings cover the fixed rent and running costs?
SELECT scenario, year,
       ROUND(gross_savings_cr, 0)                              AS savings_cr,
       ROUND(-(rent_cr + opex_cr), 0)                          AS rent_and_running_cr,
       ROUND(gross_savings_cr / -(rent_cr + opex_cr), 2)       AS cover_ratio
FROM scenario_cashflows
WHERE year IN (2029, 2033, 2038)
ORDER BY scenario, year;

-- Q7. How big is the campus next to JPMorgan and the India GCC?
SELECT s.scenario,
       ROUND(AVG(s.net_accounting_cr) * 10 / p.fx_inr_per_usd, 1)                                        AS avg_benefit_usd_m,
       ROUND(100.0 * AVG(s.net_accounting_cr) * 10 / p.fx_inr_per_usd
             / (SELECT net_income_usd_m FROM jpm_firm WHERE year = 2025), 3)                              AS pct_of_jpm_net_income,
       ROUND(100.0 * AVG(s.net_accounting_cr) / (SELECT net_profit_cr FROM gcc_india WHERE fy = 2025), 1) AS pct_of_gcc_profit
FROM scenario_cashflows s JOIN scenario_params p ON p.scenario = s.scenario
WHERE s.heads > 0
GROUP BY s.scenario, p.fx_inr_per_usd
ORDER BY s.scenario;

-- Q8. India profit pools: GCC and securities NBFC
SELECT g.fy,
       g.net_profit_cr                          AS gcc_profit_cr,
       n.pat_cr                                 AS nbfc_profit_cr,
       ROUND(g.net_profit_cr + n.pat_cr, 1)     AS combined_cr,
       ROUND(100.0 * n.pat_cr / n.total_revenue_cr, 1) AS nbfc_margin_pct
FROM gcc_india g JOIN jpmsi_nbfc n ON n.fy = g.fy
ORDER BY g.fy;
