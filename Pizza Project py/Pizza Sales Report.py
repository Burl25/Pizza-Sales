import pandas as pd
import pypyodbc as odbc
import numpy as np
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression

connection = odbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=Local host;'
    'DATABASE=Pizza Project;'
    'Trusted_Connection=yes;')

# Total revenue per month
total_revenue = pd.read_sql("SELECT DATEPART(MONTH, order_date) AS month_number, DATENAME(MONTH,order_date) AS month_name, SUM(total_price) AS total_revenue FROM orders o JOIN order_details od ON o.order_id = od.order_id GROUP BY DATENAME(MONTH,order_date), DATEPART(MONTH, order_date) ORDER BY DATEPART(MONTH, order_date)", connection)
print(total_revenue)

plt.figure(label = "Total revenue per month")
plt.plot(total_revenue['month_name'],total_revenue['total_revenue'],color = "green")
plt.title("Total revenue per month")
plt.xlabel("Month")
plt.ylabel("Revenue")
plt.grid()
plt.show()

# Revenue monthly growth rate
total_revenue['growth_rate'] = round(total_revenue['total_revenue'].pct_change() * 100,2)
print(total_revenue)

# Revenue based on pizza category
pizza_category = pd.read_sql("SELECT pt.pizza_category, SUM(od.total_price) AS total_revenue FROM order_details od JOIN pizzas p ON p.pizza_id = od.pizza_id JOIN pizza_types pt ON pt.pizza_name_id = p.pizza_name_id GROUP BY pt.pizza_category", connection)

plt.figure(label = "Percentage of Categories")
plt.pie(pizza_category['total_revenue'], labels = pizza_category['pizza_category'], autopct='%1.1f%%')
plt.title("Percentage of total revenue for pizza categories")
plt.show()

#Top pizzas based on a given date
date = '2025-05-25'
n = 3
query = f"EXEC dbo.top_pizzas @date = '{date}', @n = {n};"
top_pizzas = pd.read_sql(query, connection)

plt.figure("Top pizzas")
plt.bar(top_pizzas['pizza_name'], top_pizzas['total revenue'])
plt.title(f"Top {n} pizzas on {date}")
plt.show()

# Forecasting future revenue using Python

X = total_revenue[['month_number']]
y = total_revenue['total_revenue']

model = LinearRegression()
model.fit(X, y)

# Predictions for future months
future_months = np.array([[13],[14],[15]])
predictions = model.predict(future_months).round(2)
print(predictions)

# Forecasting graph
forecast_x = [12, 13, 14, 15]
forecast_y = [total_revenue['total_revenue'].iloc[-1], predictions[0], predictions[1], predictions[2]]
months_names_forecast = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sept', 'Oct', 'Nov', 'Dec', 'Jan 2026', 'Feb 2026', 'Mar 2026']

plt.figure("Forecast")
plt.plot(total_revenue['month_number'], total_revenue['total_revenue'], marker='o',label='Actual Revenue')
plt.plot(forecast_x, forecast_y, marker='o', linestyle='dashed', label='Forecasted Revenue')
plt.xlabel('Month')
plt.ylabel('Revenue')
plt.xticks(range(1,16), months_names_forecast)
plt.legend()
plt.grid()
plt.show()

connection.close()
