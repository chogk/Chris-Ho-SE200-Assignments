-- Question 1
-- List the top 3 employees who have processed the highest total order value in each country. 
-- Include the employee's full name, country, total order value, and their rank within the country.

WITH EmployeeOrderTotals AS (
    SELECT 
        e.Employee_ID,
        CONCAT(e.First_Name, ' ', e.Last_Name) AS full_name,
        o.Ship_Country,
        SUM(od.Unit_Price * od.Quantity * (1 - od.Discount)) AS total_order_value,
        RANK() OVER (PARTITION BY o.Ship_Country ORDER BY SUM(od.Unit_Price * od.Quantity * (1 - od.Discount)) DESC) AS country_rank
    FROM employees e
    JOIN orders o ON e.Employee_ID = o.Employee_ID
    JOIN order_details od ON o.Order_ID = od.Order_ID
    GROUP BY e.Employee_ID, full_name, o.Ship_Country
)
SELECT 
    full_name, 
    ship_country, 
    total_order_value, 
    country_rank
FROM EmployeeOrderTotals
WHERE country_rank <= 3
ORDER BY ship_country, country_rank;

-- Question 2
-- For each product, calculate its percentage of sales within its category and overall. 
-- Display the product name, category name, total product sales, percentage of category sales, and percentage of overall sales.

WITH Product_Sales AS (
    SELECT 
        p.Product_ID,
        p.Product_Name,
        c.Category_ID,
        c.Category_Name,
        SUM(od.Unit_Price * od.Quantity * (1 - od.Discount)) AS total_sales
    FROM products p
    JOIN categories c ON p.Category_ID = c.Category_ID
    JOIN order_details od ON p.Product_ID = od.Product_ID
    GROUP BY p.Product_ID, p.Product_Name, c.Category_ID, c.Category_Name
),
Category_Sales AS (
    SELECT 
        Category_ID,
        SUM(total_sales) AS total_category_sales
    FROM Product_Sales ps
    GROUP BY ps.Category_ID
),
Overall_Sales AS (
    SELECT 
        SUM(total_sales) AS total_overall_sales
    FROM Product_Sales
)
SELECT 
    ps.Product_Name,
    ps.Category_Name,
    ps.total_sales,
    (ps.total_sales / cs.total_category_sales) * 100 AS category_percentage,
    (ps.total_sales / os.total_overall_sales) * 100 AS overall_percentage
FROM product_sales ps
JOIN category_sales cs ON ps.Category_ID = cs.Category_ID
CROSS JOIN overall_sales os
ORDER BY ps.category_Name, ps.total_sales DESC;


-- Question 3
-- Identify customers who have ordered products from all categories. 
-- Display the customer's company name and the number of distinct categories they've ordered from.

WITH CustomerCategoryCount AS (
    SELECT 
        c.Customer_ID,
        c.Company_Name,
        COUNT(DISTINCT p.Category_ID) AS categories_ordered
    FROM customers c
    JOIN orders o ON c.Customer_ID = o.Customer_ID
    JOIN order_details od ON o.Order_ID = od.Order_ID
    JOIN products p ON od.Product_ID = p.Product_ID
    GROUP BY c.Customer_ID, c.Company_Name
)
SELECT 
    Company_Name, 
    categories_ordered
FROM CustomerCategoryCount
WHERE categories_ordered = (SELECT COUNT(*) FROM categories)  -- Ensure they ordered from all categories
ORDER BY Company_Name;



-- Question 4
-- Calculate a 3-order moving average of order values for each employee. 
-- Display the employee's full name, order date, total order value, and the 3-order moving average 
-- (i.e. average order value of the current and previous 2 orders).

WITH EmployeeOrders AS (
    SELECT 
        e.Employee_ID,
        CONCAT(e.First_Name, ' ', e.Last_Name) AS full_name,
        o.Order_Date,
        SUM(od.Unit_Price * od.Quantity * (1 - od.Discount)) AS total_order_value
    FROM employees e
    JOIN orders o ON e.Employee_ID = o.Employee_ID
    JOIN order_details od ON o.Order_ID = od.Order_ID
    GROUP BY e.Employee_ID, full_name, o.Order_Date
)
SELECT 
    full_name, 
    Order_Date, 
    total_order_value,
    AVG(total_order_value) OVER (
        PARTITION BY Employee_ID 
        ORDER BY Order_Date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS three_order_moving_avg
FROM EmployeeOrders
ORDER BY full_name, Order_Date;



-- Question 5
-- Rank products within each category based on their total sales, and identify products that are in the top 25% of their category. 
-- Display the product name, category name, total sales, and percentile rank.

WITH ProductSales AS (
    SELECT 
        p.Product_ID,
        p.Product_Name,
        c.Category_Name,
        SUM(od.Unit_Price * od.Quantity * (1 - od.Discount)) AS total_sales,
        PERCENT_RANK() OVER (
            PARTITION BY p.Category_ID 
            ORDER BY SUM(od.Unit_Price * od.Quantity * (1 - od.Discount)) DESC
        ) * 100 AS percentile_rank
    FROM products p
    JOIN categories c ON p.Category_ID = c.Category_ID
    JOIN order_details od ON p.Product_ID = od.Product_ID
    GROUP BY p.Product_ID, p.Product_Name, c.Category_Name, p.Category_ID
)
SELECT 
    Product_Name, 
    Category_Name, 
    total_sales, 
    percentile_rank  
FROM ProductSales
WHERE percentile_rank <= 25  -- Select top 25%
ORDER BY Category_Name, percentile_rank;
