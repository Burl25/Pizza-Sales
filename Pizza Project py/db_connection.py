import pypyodbc as odbc

def get_connection():
    connection = odbc.connect(
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER=Local host\\SQLEXPRESS;'
        'DATABASE=Pizza Project;'
        'Trusted_Connection=yes;'
    )

    return connection
