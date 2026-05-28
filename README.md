Pizza Sales Analysis Project: 
Data analysis project that combines SQL, Python and Power BI to analyse pizza sales, generate insights and build interactive dashboards.

Project Overview:
This project focuses on analysing pizza sales data from multiple perspectives:
- Database design and data processing using SQL
- Data extraction and analysis using Python
- Data visualization and business intelligence using Power BI

The goal is to transform raw sales data into actionable business insights such as revenue trends, product performance and customer purchasing behavior.

Technologies Used:
- MSSQL Server
- Python (Pandas, Numpy, Matplotlib, pypyodbc)
- Power BI

SQL Component - Creation of tables and overview of the data.
- Proper relationships between tables
- Data Processing
- Data cleaning and transformation
- Analytical queries for business insights (Revenue Summary, Every pizza total revenue, Sales level for every pizza, Revenue based on pizza category summary, Numbers of orders, Most popular pizzas to least, Number of orders at every hour, Number of orders every month, Total revenue based on month, Best-selling pizza by month, Peak sales days, Best to least profitable sizes)
- Stored procedures for reusable analysis (Daily sales report based on the period of time selected, Monthly sales report by category, Top N pizzas based on total revenue from a given date, Worst-selling pizzas based on quantity in a given month) 
- User-defined functions (Total revenue of an order, Total revenue by date, Total number of pizzas based on sizes, Possible discount)

Python Component - Python is used to connect to SQL Server and perform further analysis.

Key Features:
- Connection to SQL Server using pypyodbc
- Data extraction using SQL queries
- Data analysis using Pandas
- Visualization using Matplotlib
Analyses Performed:
- Sales Summaries (total price summary, quantity summary, unit price summary)
- Sales Report (total revenue per month, total of pizzas ordered by category and size)
- Revenue trends over time (total orders per hour and per month, forecast revenue for next 3 months)
- Product-level performance analysis (percentage of total revenue for categories, top pizzas on a given date, function created to find given ingredients)

Power BI Dashboard - Dashboard created in Power BI for business intelligence and reporting.

- Executive Overview (Total Revenue, Total Orders, Average Order Value, Revenue trend over time, Monthly growth)
- Product Performance (Top selling pizzas, Worst performing pizzas, Revenue by category, Revenue by size)
- Sales Trends (Orders by hour, Orders by month, Peak order periods, Seasonality analysis)

## Project Structure

```text
Pizza Sales/
│
├── Pizza Project sql/
│   ├── Data Analysis.sql
│   ├── Data Import.sql
│   ├── Function and Procedures.sql
│
├── Pizza Project py/
│   ├── db_connection.py
│   ├── Pizza project - order_details.py
│   ├── Pizza project - orders.py
│   ├── Pizza project - pizza_types.py
│   ├── Pizza project - pizzas.py
│   ├── Pizza Sales Report.py
│   ├── Graphs/
│
├── Power BI Project Theme/
│   ├── gradient.png
│   ├── Pizza Sales Theme.json
│
├── Pizza Sales Dashboard.pbix
├── pizza_sales.csv
│
└── README.md
```


Author:
Ioana Burlaciuc
GitHub: https://github.com/Burl25

License:
This project is for educational and portfolio purposes.
