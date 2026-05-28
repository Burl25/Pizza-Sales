import pandas as pd
import pypyodbc as odbc
import numpy as np
import matplotlib.pyplot as plt
import calendar

connection = odbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=Local host;'
    'DATABASE=Pizza Project;'
    'Trusted_Connection=yes;')

# Read data with cursor

# cursor = connection.cursor()
# cursor.execute("SELECT * FROM orders")
# rows = cursor.fetchall()
# for row in rows:
#     print(row)
# connection.close()

# Read data directly with pandas

df_orders = pd.read_sql("SELECT * FROM orders", connection)

orders_dates = pd.read_sql("SELECT DATENAME(month, order_date) as 'month', COUNT(order_id) as number_of_orders FROM orders GROUP BY DATENAME(month, order_date)", connection)
count_months = pd.read_sql("SELECT COUNT(order_id) as number_of_orders FROM orders GROUP BY DATENAME(month, order_date)", connection)
months_order = list(calendar.month_name)[1:]
orders_dates['month'] = pd.Categorical(orders_dates['month'], categories = months_order)
orders_dates = orders_dates.sort_values('month')

order_time = pd.read_sql("SELECT DATEPART(hour, order_time) as 'hour', COUNT(order_id) as number_of_orders FROM orders GROUP BY DATEPART(hour, order_time) ORDER BY 'hour'", connection)

print("--------------------------------------------------")
print("Orders table")
print(df_orders.head())
print("--------------------------------------------------")
print("Shape: ",df_orders.shape)
print("--------------------------------------------------")
print("Data types:")
print(df_orders.dtypes)
print("--------------------------------------------------")

print("Orders summary")
print()
print("Orders per month:")
print(orders_dates)
print()
print("Orders per hour:")
print(order_time)

plt.figure(label = "Orders summary")

plt.subplot(2,1,1)
plt.bar(orders_dates['month'], orders_dates['number_of_orders'], color = "black")
plt.title("Number of orders per month")
plt.xlabel("Month")
plt.ylabel("Number of orders")

plt.subplot(2,1,2)
plt.bar(order_time['hour'],order_time['number_of_orders'],color = "red")
plt.title("Number of orders per hour")
plt.xticks(np.reshape(order_time['hour'],(-1)))
plt.xlabel("Hour")
plt.ylabel("Number of orders")

plt.tight_layout()
plt.show()

connection.close()