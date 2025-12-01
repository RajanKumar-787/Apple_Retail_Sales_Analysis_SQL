# Apple Retail Sales Analysis

## Project Overview
This project analyzes 1M+ Apple Retail sales and warranty records using SQL to answer 25 real business questions. It includes database design with five tables, ERD creation, exploratory data analysis, complex SQL queries using CTEs and window functions, and indexing to improve overall query performance.

## Table of Contents
- [Problem Statement](#problem-statement)
- [Tech Stack](#tech-stack)
- [Dataset](#dataset)
- [Database Schema](#database-schema)
- [ERD (Entity Relationship Diagram)](#erd-entity-relationship-diagram)
- [Project Structure](#project-structure)
- [Business Problems Solved](#business-problems-solved)
- [Key Insights](#key-insights)
- [Business Recommendations](#business-recommendations)
- [Author & Contact](#author--contact)

## Problem Statement
Apple Retail stores generate large volumes of sales and warranty data across multiple regions. Without proper analysis, it becomes difficult to identify which products generate the most revenue, which stores perform best, why certain countries experience higher warranty claims, or why premium products show a higher number of warranty complaints.

This project uses SQL to analyze these patterns and provide meaningful insights that support better decisions in improving product quality, reducing warranty issues, and maximizing sales growth.

## Tech Stack
- **Database:** PostgreSQL
- **SQL:** Joins, CTEs, Window Functions, Case Statement, Indexing
- **IDE:** pgAdmin 4

## Dataset
This project uses five CSV files stored inside the `dataset` directory:
- `stores.csv`
- `category.csv`
- `products.csv`
- `sales.csv`
- `warranty.csv`

Each CSV file represents one table in the SQL database.

## Database Schema

The project uses five main tables:

**1. stores:** Contains information about Apple retail stores.
- `store_id` - Unique identifier for each store.
- `store_name` - Name of the store.
- `city` - City where the store is located.
- `country` - Country of the store.

**2. category:** Holds product category information.
- `category_id` - Unique identifier for each product category.
- `category_name` - Name of the category.

**3. products:** Details about Apple products.
- `product_id` - Unique identifier for each product.
- `product_name` - Name of the product.
- `category_id` - References the category table.
- `launch_date` - Date when the product was launched.
- `price` - Price of the product.

**4. sales:** Stores sales transactions.
- `sale_id` - Unique identifier for each sale.
- `sale_date` - Date of the sale.
- `store_id` - References the store table.
- `product_id` - References the product table.
- `quantity` - Number of units sold.

**5. warranty:** Contains information about warranty claims.
- `claim_id` - Unique identifier for each warranty claim.
- `claim_date` - Date the claim was made.
- `sale_id` - References the sales table.
- `repair_status` - Status of the warranty claim (e.g., Completed, In Progress, Pending, Rejected).

## ERD (Entity Relationship Diagram)
![ERD Diagram](https://github.com/RajanKumar-787/Apple_Retail_Sales_Analysis_SQL/blob/47a8ea0a5dc4f67250e1c5a9a5afe51874162b89/Images/ERD%20Diagram.png)

## Project Structure
```
Apple_Retail_Sales_Analysis_SQL/
|
├── Dataset/
│   └── sales.zip
│       └── sales.csv
│   └── stores.csv
│   └── products.csv
│   └── category.csv
│   └── warranty.csv
|
├── Images/
│   └── ERD Diagram.png
│  
├── Queries/
│   └── apple_retail_sales_analysis.sql
|
├── README.md
```

## Business Problems Solved

##### [View Full SQL Queries](https://github.com/RajanKumar-787/Apple_Retail_Sales_Analysis_SQL/blob/ed0801126d9d3de9717bf08fc4ed43973db66743/Queries/apple_retail_sales_analysis.sql)

1. Find the number of stores in each country.
2. Calculate the total number of units sold by each store.
3. Identify how many sales occurred in December 2023.
4. Determine how many stores have never had a warranty claim filed.
5. Calculate the percentage of warranty claims marked as "Rejected".
6. Identify which store had the highest total units sold in the last year.
7. Count the number of unique products sold in the last year.
8. Find the average price of products in each category.
9. How many warranty claims were filed in 2020?
10. For each store, identify the best-selling day based on highest quantity sold.
11. Which country generates the highest revenue?
12. Which store performs best by units sold?
13. Which product generates the most revenue?
14. Which product category leads in revenue?
15. Identify the least selling product in each country for each year based on total units sold.
16. Calculate how many warranty claims were filed within 180 days of a product sale.
17. Determine how many warranty claims were filed for products launched in the last two years.
18. List the months in the last three years where sales exceeded 5,000 units in the United States.
19. Identify the product category with the most warranty claims filed in the last two years.
20. Determine the percentage chance of receiving warranty claims after each purchase for each country.
21. Analyze the year-by-year growth ratio for each store.
22. Calculate the correlation between product price and warranty claims for products sold in the last five years, segmented by price range.
23. Identify the store with the highest percentage of "Rejected" claims relative to total claims filed.
24. Write a query to calculate the monthly running total of sales for each store over the past four years and compare trends during this period.
25. Analyze product sales trends over time, segmented into key periods: from launch to 6 months, 6-12 months, 12-18 months, and beyond 18 months.

## Key Insights

1. The United States generates the highest revenue, making it Apple's strongest and most profitable market.
2. The "Apple Dubai Mall" store performs the best, generating the highest total revenue among all stores.
3. Apple Music products generate the most revenue among all products, proving their strong and consistent customer demand.
4. Tablet category leads in overall revenue, highlighting its popularity and strong sales performance.
5. Premium products (priced above $1000) receive the highest number of warranty complaints, suggesting a gap between product quality and customer expectations for premium items.
6. Many warranty claims are filed within the first 180 days of purchase, indicating early product issues or improper customer usage.
7. Taiwan reports the most warranty claims, suggesting possible quality, usage, or environmental challenges in that region.

## Business Recommendations

1. Boost inventory and marketing efforts in the United States, as it contributes the highest revenue.
2. Use the success of the "Apple Park Visitor Center" store as a model to improve performance in lower-selling stores.
3. Invest more in Apple Music product marketing since it is the top revenue generator.
4. Increase promotions for the Tablet category to capitalize on its strong market demand.
5. Improve quality checks for premium products to reduce warranty complaints and enhance customer satisfaction.
6. Analyze early warranty claims to identify recurring product issues or provide better usage guidance to customers.
7. Investigate high warranty claims in Taiwan and improve customer support or product training there to reduce service pressure and increase satisfaction.

## Author & Contact

**Author:** Rajan Kumar  
**Email:** rajaninranchi787@gmail.com  
**GitHub:** [https://github.com/RajanKumar-787](https://github.com/RajanKumar-787)  
**LinkedIn:** [https://www.linkedin.com/in/rajankumar787/](https://www.linkedin.com/in/rajankumar787/)  

⭐ If you found this project helpful, please consider giving it a star!  
💬 Feedback and suggestions are always welcome!  
