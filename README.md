# 🛒 End-to-End E-commerce Data Analysis (SQL)

## 📌 Project Overview
This repository contains a robust suite of **25 SQL analytical queries** designed to transform raw e-commerce data into actionable business intelligence. The project covers the entire data lifecycle within SQL—from basic data retrieval and filtering to complex analytical reporting and database engineering.

---

## 🚀 The 4 Pillars of This Project

### 1. 👥 Customer Intelligence
Beyond basic retrieval, this project implements deep behavioral analysis:
* **VIP Identification:** Segmenting customers who spent over 10,000.
* **Churn Analysis:** Detecting registered customers with zero purchase history.
* **Engagement Metrics:** Ranking customers by order frequency and product diversity.

### 2. 💰 Sales & Revenue Performance
Advanced financial reporting to track business growth:
* **Revenue Trends:** Monthly total sales and growth analysis.
* **Product Performance:** Identifying "Star" products based on their percentage contribution to total revenue.
* **Order Metrics:** Calculating Average Order Value (AOV) and ranking top-performing customers.

### 3. 📦 Inventory & Catalog Management
Practical business logic for stock optimization:
* **Dead Stock Detection:** Identifying products that have never been ordered to optimize inventory.
* **Smart Pricing Tiers:** Using `CASE` statements to categorize the catalog into High, Medium, and Low price ranges.
* **Category Deep-dives:** Statistical analysis of prices and sales across different subcategories.

### 4. 🛠️ Database Engineering & Optimization
Showcasing professional SQL development skills:
* **Performance:** Optimized filtering using date-range logic.
* **Advanced Logic:** Extensive use of **Common Table Expressions (CTEs)** and **Window Functions** (`RANK`, `OVER`, `PARTITION BY`).
* **Automation:** Implementing **Stored Procedures** for dynamic querying and **Views** for simplified reporting.
* **Data Integrity:** Using **Transactions** to ensure secure database object creation.

---

## 📂 Project Structure
* `analysis_queries.sql`: The main script containing 25 categorized analytical queries.
* `schema_setup.sql`: (Optional) Script to initialize the `ecommercedb` and sample data.
* `README.md`: Project documentation.

---

## 📊 Key Featured Query
One of the highlights of this project is the **Sales Contribution Analysis**, which uses window functions to calculate exactly what percentage of total company revenue each product generates:

```sql
SELECT 
    p.productname,
    SUM(od.quantity * od.unitprice) AS productsales,
    ROUND((SUM(od.quantity * od.unitprice) / SUM(SUM(od.quantity * od.unitprice)) OVER()) * 100, 2) AS sales_percentage
FROM orderdetails od
JOIN products p ON od.productid = p.productid
GROUP BY p.ProductID, p.ProductName
ORDER BY sales_percentage DESC;

---

I’m a Data Analyst passionate about turning complex data into visual stories. Feel free to reach out for collaboration or questions:

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue?style=for-the-badge&logo=linkedin)](https://www.linkedin.com/in/samir-hendawy-530124231)
[![Kaggle](https://img.shields.io/badge/Kaggle-Profile-00AFEF?style=for-the-badge&logo=kaggle&logoColor=white)](https://www.kaggle.com/samerhendawy)
