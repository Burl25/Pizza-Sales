import pandas as pd
import pypyodbc as odbc
import numpy as np
import matplotlib as plt

connection = odbc.connect(
    'DRIVER={ODBC Driver 17 for SQL Server};'
    'SERVER=Local host;'
    'DATABASE=Pizza Project;'
    'Trusted_Connection=yes;')

sum_orders = pd.read_sql("SELECT SUM(quantity) FROM order_details GROUP BY order_id", connection)
sum_total_price = pd.read_sql("SELECT SUM(total_price) FROM order_details GROUP BY order_id",connection)
df_order_details = pd.read_sql("SELECT * FROM order_details", connection)

print("--------------------------------------------------")
print("Order details table")
print(df_order_details.head())
print("--------------------------------------------------")
print("Shape: ",df_order_details.shape)
print("--------------------------------------------------")
print("Data types:")
print(df_order_details.dtypes)
print("--------------------------------------------------")

print("Quantity summary")
print(round(sum_orders.describe(),2))
print("--------------------------------------------------")

print("Total price summary")
print(round(sum_total_price.describe(),2))
print("--------------------------------------------------")

connection.close()