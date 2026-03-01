-- DATABASE
USE ecommercedb;

-- ===========================================================================================
-- SECTION 1: BASIC DATA RETRIEVAL & FILTERING 
-- ===========================================================================================

-- -------------------------------------------------------------------------------------------
-- 1. Retrieve all customer names and their corresponding emails
-- -------------------------------------------------------------------------------------------
SELECT 
	CONCAT(FirstName," ", LastName) AS CustomerName,
    Email 
FROM 
	customers;
-- -------------------------------------------------------------------------------------------
-- 2. Display all orders that have a total amount greater than 10,000
-- -------------------------------------------------------------------------------------------
SELECT 
	* 
FROM 
	orders 
WHERE 
	TotalAmount > 10000;
-- -------------------------------------------------------------------------------------------
-- 3. Retrieve the top 5 most expensive products
-- -------------------------------------------------------------------------------------------
SELECT ProductName FROM products ORDER BY price DESC LIMIT 5;
-- -------------------------------------------------------------------------------------------
-- 4. Retrieve all orders placed in the year 2024 (Optimized version)
-- -------------------------------------------------------------------------------------------
SELECT 
	* 
FROM 
	orders 
WHERE 
	orderdate >= '2024-01-01' AND orderdate <= '2024-12-31';
-- -------------------------------------------------------------------------------------------
-- 5. Categorize products into “High”, “Medium”, or “Low” price ranges using CASE
-- -------------------------------------------------------------------------------------------
SELECT	
	productname,
	CASE 
		WHEN price BETWEEN 0 AND 300 THEN "Low"
        WHEN price BETWEEN 301 AND 700 THEN "Medium" 
        WHEN price > 700 THEN "High" 
        ELSE "Uncategorized"
	END AS price_range
FROM
	products;
-- -------------------------------------------------------------------------------------------



-- ===========================================================================================
-- SECTION 2: JOINS & RELATIONSHIP ANALYSIS 
-- ===========================================================================================

-- -------------------------------------------------------------------------------------------
-- 6. List all products along with their category and subcategory names
-- -------------------------------------------------------------------------------------------
SELECT 
	P.ProductName, C.CategoryName, SC.SubcategoryName
FROM products AS P
LEFT JOIN subcategories AS sc 
	ON P.SubcategoryID = SC.SubcategoryID
LEFT JOIN categories AS C
	ON SC.CategoryID = C.CategoryID;
-- -------------------------------------------------------------------------------------------
-- 7. Find all customers who haven’t placed any orders
-- -------------------------------------------------------------------------------------------
SELECT 
	CONCAT(C.FirstName," ", C.LastName) AS CustomerName 
FROM customers c 
LEFT JOIN orders o 
	ON c.customerid = o.customerid 
WHERE 
	o.orderid IS NULL;
-- -------------------------------------------------------------------------------------------
-- 8. Write a query to display all products that were never ordered
-- -------------------------------------------------------------------------------------------
SELECT 
	p.* FROM 
	products p 
LEFT JOIN 
	orderdetails od 
ON 
	p.productid = od.productid 
WHERE 
	od.productid IS NULL;
-- -------------------------------------------------------------------------------------------


-- ===========================================================================================
-- SECTION 3: AGGREGATIONS & BUSINESS METRICS (الإحصائيات ومؤشرات الأداء)
-- ===========================================================================================


-- -------------------------------------------------------------------------------------------
-- 9. Find the total number of orders placed by each customer
-- -------------------------------------------------------------------------------------------
SELECT 
	CONCAT(C.FirstName," ", C.LastName) AS CustomerName,
	COUNT(o.CustomerID) AS total_order
FROM customers c
LEFT JOIN orders o
ON c.customerid = o.customerid
GROUP BY C.CustomerID, C.FirstName, C.LastName
ORDER BY total_order DESC;
-- -------------------------------------------------------------------------------------------
-- 10. List all orders along with their total number of order items
-- -------------------------------------------------------------------------------------------
SELECT 
	o.orderid,
	COUNT(od.OrderID) AS total_number
 FROM orders o 
 LEFT JOIN orderdetails od 
	ON o.orderid = od.orderid
GROUP BY o.orderid;

-- -------------------------------------------------------------------------------------------
-- 11. Display the total sales for each product category (Product Level & Category Level)
-- -------------------------------------------------------------------------------------------

-- FOR PRODUCTS
SELECT
	p.productname,
    SUM(Totalamount) AS totalsales
FROM products p 
LEFT JOIN orderdetails od
	ON P.productid = od.productid
LEFT JOIN orders o 
ON od.orderid = o.orderid
GROUP BY p.productid, p.productname;

-- -------------------------------------------------------------------------------------------

-- FOR CATEGORY
SELECT 
    c.CategoryName, SUM(o.TotalAmount) AS TotalSales
FROM
    categories c
        LEFT JOIN
    subcategories sc ON c.CategoryID = sc.CategoryID
        LEFT JOIN
    products p ON sc.SubcategoryID = p.SubcategoryID
        LEFT JOIN
    orderdetails od ON p.ProductID = od.ProductID
        LEFT JOIN
    orders o ON od.OrderID = o.OrderID
GROUP BY c.CategoryID , c.CategoryName;
-- -------------------------------------------------------------------------------------------
-- 12. Show the average product price per subcategory
-- -------------------------------------------------------------------------------------------
SELECT 
	SC.SubcategoryName,
	ROUND(AVG(P.price), 2) AS avg_price 
FROM subcategories AS sc 
LEFT JOIN products AS p 
	ON sc.SubcategoryID = p.SubcategoryID
GROUP BY SC.SubcategoryName;
-- -------------------------------------------------------------------------------------------
-- 13. Find customers who have ordered more than 3 different products
-- -------------------------------------------------------------------------------------------
SELECT 
	CONCAT(C.FirstName," ", C.LastName) AS CustomerName,
    COUNT(DISTINCT od.productid) AS num_diff_products
FROM customers c 
LEFT JOIN orders o 
	ON c.customerid = o.customerid 
LEFT JOIN orderdetails od 
	ON o.orderid = od.orderid
GROUP BY C.CustomerID, C.FirstName, C.LastName
HAVING num_diff_products > 3;
-- -------------------------------------------------------------------------------------------
-- 14. Display the highest and lowest order total for each customer
-- -------------------------------------------------------------------------------------------
SELECT 
    CONCAT(C.FirstName," ", C.LastName) AS CustomerName,
    MAX(o.TotalAmount) AS HighestOrder,
    MIN(o.TotalAmount) AS LowestOrder
FROM customers c 
INNER JOIN orders o 
	ON c.customerid = o.customerid
GROUP BY C.CustomerID, C.FirstName, C.LastName;
-- -------------------------------------------------------------------------------------------
-- 15. Write a query to count customers with more than 5 orders
-- -------------------------------------------------------------------------------------------
SELECT 
	CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
    count(o.orderid) as ordercount
FROM customers c 
LEFT JOIN orders o 
ON c.customerid = o.customerid
GROUP BY C.CustomerID, C.FirstName, C.LastName
HAVING ordercount > 5;
-- -------------------------------------------------------------------------------------------
-- 16. Show the total revenue per month
-- -------------------------------------------------------------------------------------------
SELECT 
	MONTHNAME(OrderDate) AS Monthh,
	SUM(TotalAmount) AS TotalAmount
FROM ORDERS 
GROUP BY 1;
-- -------------------------------------------------------------------------------------------
-- 17. List all customers who placed orders in more than one subcategory
-- -------------------------------------------------------------------------------------------
SELECT 
	c.CustomerID, 
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
	COUNT(DISTINCT p.SubCategoryID) AS SubCategoryCount
FROM customers AS c 
INNER JOIN orders AS o 
ON c.customerid = o.customerid 
INNER JOIN orderdetails od 
ON o.orderid = od.orderid
INNER JOIN products AS p
ON od.productid = p.productid
GROUP BY c.CustomerID, c.FirstName, c.LastName
HAVING SubCategoryCount > 1;

-- ===========================================================================================
-- SECTION 4: ADVANCED ANALYTICS & WINDOW FUNCTIONS 
-- ===========================================================================================

-- -------------------------------------------------------------------------------------------
-- 18. Use a non-recursive CTE to display total sales by category
-- -------------------------------------------------------------------------------------------
WITH salescategory AS (
SELECT 
	c.categoryname,
    SUM(o.totalamount) AS totalamount
FROM categories c 
LEFT JOIN subcategories sc
	ON c.categoryid = sc.categoryid
LEFT JOIN products p 
	ON sc.subcategoryid = p.subcategoryid
LEFT JOIN orderdetails od 
	ON p.productid = od.productid
LEFT JOIN orders o
	ON od.orderid = o.orderid
GROUP BY c.categoryname
)
SELECT * FROM salescategory;
-- -------------------------------------------------------------------------------------------
-- 19. Find the customer who spent the most money overall using RANK()
-- -------------------------------------------------------------------------------------------
WITH RankedCustomers AS (
    SELECT 	
        CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
        SUM(O.TotalAmount) AS total_spent,
        RANK() OVER (ORDER BY SUM(O.TotalAmount) DESC) AS customer_rank
    FROM customers c 
    LEFT JOIN orders o ON c.customerid = o.customerid 
    GROUP BY C.CustomerID, C.FirstName, C.LastName
)
SELECT CustomerName, total_spent
FROM RankedCustomers
WHERE customer_rank = 1;
-- -------------------------------------------------------------------------------------------
-- 20. Retrieve the top 3 customers by total sales using a window function
-- -------------------------------------------------------------------------------------------
SELECT * FROM(
SELECT 
	CONCAT(c.FirstName, " ", c.LastName) AS customername,
    SUM(o.TotalAmount) AS TotalAmount,
    RANK() OVER(ORDER BY SUM(o.TotalAmount) DESC) AS total_amount_ranked
FROM customers c 
INNER JOIN orders o 
	ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.FirstName, c.LastName) AS amount_ranked
WHERE total_amount_ranked <= 3;
-- -------------------------------------------------------------------------------------------
-- 21. Calculate each product’s sales percentage compared to total sales
-- -------------------------------------------------------------------------------------------
SELECT 
	p.productname,
    SUM(Od.quantity*Od.unitprice) AS productsales,
    ROUND((SUM(od.quantity * od.unitprice) / SUM(SUM(od.quantity * od.unitprice)) OVER()) * 100, 2) AS sales_percentage
FROM orders AS o 
INNER JOIN orderdetails od 
ON o.orderid = od.orderid
INNER JOIN products AS p
ON od.productid = p.productid
GROUP BY p.ProductID, p.ProductName
ORDER BY sales_percentage DESC;
-- -------------------------------------------------------------------------------------------
-- 22. Find the average order value per customer using a window function
-- -------------------------------------------------------------------------------------------
SELECT 
	CONCAT(c.FirstName, " ", c.LastName) AS customername,
    o.OrderID,
    o.TotalAmount,
    AVG(O.totalamount) OVER(PARTITION BY c.customerid) AS avg_amount,
    o.TotalAmount - AVG(o.TotalAmount) OVER(PARTITION BY c.CustomerID) AS Difference
FROM customers c LEFT JOIN orders o 
	ON c.customerid = o.customerid;
    
-- -------------------------------------------------------------------------------------------
-- 23. Rank all products by total sales amount using a window function
-- -------------------------------------------------------------------------------------------
SELECT 
	p.productname,
	SUM(o.totalamount) AS totalsales,
    RANK() OVER(ORDER BY SUM(o.totalamount) DESC) AS ranked_product
FROM orders AS o 
INNER JOIN orderdetails od 
ON o.orderid = od.orderid
INNER JOIN products AS p
ON od.productid = p.productid
GROUP BY p.ProductID, p.ProductName; 
-- -------------------------------------------------------------------------------------------


-- ===========================================================================================
-- SECTION 5: DATABASE OBJECTS (VIEWS & STORED PROCEDURES) (الكائنات البرمجية)
-- ===========================================================================================


-- -------------------------------------------------------------------------------------------
-- 24. Create a view that shows customer name, order ID, and total order amount
-- -------------------------------------------------------------------------------------------
START TRANSACTION;
DROP VIEW IF exists customerr;
CREATE VIEW customerr AS 
	SELECT 
		CONCAT(C.FirstName, ' ', C.LastName) AS CustomerName,
		O.OrderID,
		O.TotalAmount
	FROM customers C
	INNER JOIN orders O ON C.CustomerID = O.CustomerID;
COMMIT;
SELECT * FROM customerr;
-- -------------------------------------------------------------------------------------------
-- 25. Write a stored procedure to get all orders for a specific customer
-- -------------------------------------------------------------------------------------------
DROP PROCEDURE IF EXISTS specific_customer;
DELIMITER //
CREATE PROCEDURE specific_customer(IN custid INT)
BEGIN
	SELECT * FROM orders WHERE customerid = custid;
END //
DELIMITER ;

-- CALL Procedure Example
CALL specific_customer(1);

-- -------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------

