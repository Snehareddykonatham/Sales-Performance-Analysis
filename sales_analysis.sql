SELECT *
FROM Sales
LIMIT 10;

SELECT COUNT(*) AS Total_Records
FROM Sales;

--This produces three important business KPIs: total revenue, total profit, and profit margin.
SELECT
    ROUND(SUM(Sales), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(SUM(Profit) * 100.0 /
          NULLIF(SUM(Sales), 0), 2) AS Profit_Margin_Percent
FROM Sales;

--Regional Sales Analysis
SELECT
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM Sales
GROUP BY Region
ORDER BY Total_Sales DESC;

--Regional Sales Analysis
SELECT
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) * 100.0 /
        NULLIF(SUM(Sales), 0), 2
    ) AS Profit_Margin_Percent
FROM Sales
GROUP BY Region
ORDER BY Profit_Margin_Percent DESC;

-- Query 4: Calculate profit margin by region
-- Business Question: Which region is most profitable?
SELECT
    Region,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) * 100.0 /
        NULLIF(SUM(Sales), 0), 2
    ) AS Profit_Margin_Percent
FROM Sales
GROUP BY Region
ORDER BY Profit_Margin_Percent DESC;

-- Query 5: Sales and profit by product category
-- Business Question: Which product category
-- generates the highest revenue and profit?

SELECT
    Category,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) * 100.0 /
        NULLIF(SUM(Sales), 0), 2
    ) AS Profit_Margin_Percent
FROM Sales
GROUP BY Category
ORDER BY Total_Sales DESC;

-- Query 6: Top 10 products by revenue
-- Business Question:
-- Which products generate the highest sales?

SELECT
    "Product Name",
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    SUM(Quantity) AS Total_Quantity
FROM Sales
GROUP BY "Product Name"
ORDER BY Total_Sales DESC
LIMIT 10;

-- Query 7: Monthly sales trend analysis
-- Business Question:
-- How do revenue and profit change over time?

WITH FormattedDates AS (
    SELECT
        substr("Order Date", -4) AS Order_Year,
        printf('%02d',
            CAST("Order Date" AS INTEGER)
        ) AS Order_Month,
        Sales,
        Profit
    FROM Sales
)

SELECT
    Order_Year || '-' || Order_Month AS Year_Month,
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM FormattedDates
GROUP BY Order_Year, Order_Month
ORDER BY Order_Year, Order_Month;

-- Query 8: Furniture profitability analysis
-- Business Question:
-- Which furniture subcategories have low profit?

SELECT
    "Sub-Category",
    ROUND(SUM(Sales), 2) AS Total_Sales,
    ROUND(SUM(Profit), 2) AS Total_Profit,
    ROUND(
        SUM(Profit) * 100.0 /
        NULLIF(SUM(Sales), 0), 2
    ) AS Profit_Margin_Percent
FROM Sales
WHERE Category = 'Furniture'
GROUP BY "Sub-Category"
ORDER BY Total_Profit ASC;

-- Query 9: Discount impact on furniture profit
-- Business Question:
-- Are higher discounts associated with lower profits?

SELECT
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount <= 0.20 THEN '1-20%'
        WHEN Discount <= 0.40 THEN '21-40%'
        ELSE 'Above 40%'
    END AS Discount_Range,

    COUNT(*) AS Total_Records,

    ROUND(AVG(Discount) * 100, 2)
        AS Average_Discount_Percent,

    ROUND(SUM(Sales), 2) AS Total_Sales,

    ROUND(SUM(Profit), 2) AS Total_Profit

FROM Sales
WHERE Category = 'Furniture'

GROUP BY Discount_Range

ORDER BY Average_Discount_Percent;

-- Query 10: Profit margin by discount range
-- Business Question:
-- How does discounting relate to profitability?

SELECT
    CASE
        WHEN Discount = 0 THEN 'No Discount'
        WHEN Discount <= 0.20 THEN '1-20%'
        WHEN Discount <= 0.40 THEN '21-40%'
        ELSE 'Above 40%'
    END AS Discount_Range,

    ROUND(SUM(Sales), 2) AS Total_Sales,

    ROUND(SUM(Profit), 2) AS Total_Profit,

    ROUND(
        SUM(Profit) * 100.0 /
        NULLIF(SUM(Sales), 0), 2
    ) AS Profit_Margin_Percent

FROM Sales
WHERE Category = 'Furniture'

GROUP BY Discount_Range

ORDER BY
    CASE Discount_Range
        WHEN 'No Discount' THEN 1
        WHEN '1-20%' THEN 2
        WHEN '21-40%' THEN 3
        ELSE 4
    END;