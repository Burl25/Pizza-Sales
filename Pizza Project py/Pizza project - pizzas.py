import pandas as pd
import numpy as np
import matplotlib as plt
from db_connection import get_connection

connection = get_connection()


df_pizzas = pd.read_sql("SELECT * FROM pizzas", connection)
pizzas_sizes = pd.read_sql("SELECT pizza_size, COUNT(pizza_size) AS number_of_pizzas FROM pizzas GROUP BY pizza_size", connection)
sizes_order = ['S', 'M', 'L', 'XL', 'XXL']
pizzas_sizes['pizza_size'] = pd.Categorical(pizzas_sizes['pizza_size'], categories = sizes_order)
pizzas_sizes = pizzas_sizes.sort_values('pizza_size')

print("--------------------------------------------------")
print("Pizzas table")
print(df_pizzas.head())
print("--------------------------------------------------")
print("Shape: ",df_pizzas.shape)
print("--------------------------------------------------")
print("Data types:") 
print(df_pizzas.dtypes)
print("--------------------------------------------------")

print("Unit price summary")
print(round(df_pizzas["unit_price"].describe(),2))
print("--------------------------------------------------")

print("Pizza size summary")
print(pizzas_sizes)
print("--------------------------------------------------")

connection.close()