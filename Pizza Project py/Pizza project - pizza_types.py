import pandas as pd
import numpy as np
import matplotlib as plt
from db_connection import get_connection

connection = get_connection()

df_pizza_types = pd.read_sql("SELECT * FROM pizza_types", connection)
pizza_categories = pd.read_sql("SELECT pizza_category, COUNT (pizza_category) AS number_of_pizzas FROM pizza_types GROUP BY pizza_category", connection)
pizza_names = pd.read_sql("SELECT DISTINCT pizza_name, pizza_ingredients FROM pizza_types", connection)

print("--------------------------------------------------")
print("Pizza type table")
print(df_pizza_types.head())
print("--------------------------------------------------")
print("Shape: ",df_pizza_types.shape)
print("--------------------------------------------------")
print("Data types:")
print(df_pizza_types.dtypes)
print("--------------------------------------------------")

print("Pizza categories summary")
print(pizza_categories)
print("--------------------------------------------------")

# Function to search for an igredient in any pizza
def find_ingredient(pizza_name,*ingredients):
    for i in range(0,len(pizza_names)):
        if pizza_names['pizza_name'][i] == pizza_name:
            pizza_ingredients = pizza_names['pizza_ingredients'][i]
            found = []
            not_found = []

            for ingredient in ingredients:
                if ingredient.lower() in pizza_ingredients.lower():
                    found.append(ingredient)
                else:
                    not_found.append(ingredient)
            
            if found and not not_found:
                return f"Ingredients found: {', '.join(found)}"
            elif not_found and not found:
                return f"Ingredients not found: {', '.join(not_found)}"
            else:
                return (f"Ingredients found: {', '.join(found)}\n"
                        f"Ingredients not found: {', '.join(not_found)}")
            
    return ("Pizza not found")
    
print(find_ingredient("The PepperSalami Pizza","Salami","Jalapeno","CHEESE","mushrooms"))
print("--------------------------------------------------")

connection.close()
