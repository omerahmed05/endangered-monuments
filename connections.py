from flask import Flask, render_template, request, redirect, url_for, jsonify
import mysql.connector
from mysql.connector import Error

"""
When this program is ran using python connections.py, flask starts a web server that listens for requests.
"""
app = Flask(__name__)

config = {
    'host': 'sql5.freesqldatabase.com',
    'port': 3306,
    'user': 'sql5770619',
    'password': 'u6HGSk77Qp',
    'database': 'sql5770619'
}

"""
When someone visits the root URL (e.g. localhost:5000), this function returns the html file in templates which is displayed by flask onto the webpage. 
"""
@app.route('/')
def index():
    return render_template('index.html')

"""
Accepts submissions from index.html and adds it to the DBMS
"""
@app.route('/api/add', methods=['POST'])
def add():
    # Get JSON data from request
    data = request.json
    
    # Extract table and data from request
    table_name = data.get('table')
    item_data = data.get('data')
    
    # Create connection to MySQL
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor()
    
    # Dynamically build the SQL query based on the table and provided columns
    columns = []
    values = []
    placeholders = []
    
    for column, value in item_data.items():
        columns.append(column)
        values.append(value)
        placeholders.append("%s")  # Using %s as placeholder for all types
    
    columns_str = ", ".join(columns)
    placeholders_str = ", ".join(placeholders)
    
    # Create the INSERT statement
    sql = f"INSERT INTO {table_name} ({columns_str}) VALUES ({placeholders_str})"
    
    # Execute the query
    cursor.execute(sql, values)
    conn.commit()
        
    cursor.close()
    conn.close()
    
    return jsonify({
        'success': True,
        'message': f'Data added successfully to {table_name}',
    })

"""_summary_
Accepts primary key submissions from index.html and removes from the DBMS
"""
@app.route('/api/delete', methods=['POST'])
def delete():
    # Get JSON data from request
    data = request.json
    
    # Extract required information
    table = data.get('table')
    primary_key_column = data.get('primaryKeyColumn')
    primary_key_value = data.get('primaryKeyValue')
    
    # Connect to database
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor()
    
    # Create SQL query using parameterized query
    query = f"DELETE FROM {table} WHERE {primary_key_column} = %s"
    
    # Execute query with parameter
    cursor.execute(query, (primary_key_value,))
    
    # Commit the transaction
    conn.commit()
    
    # Close cursor and connection
    cursor.close()
    conn.close()
    
    # Return response
    return jsonify({
        'success': True,
        'message': f'Successfully deleted record from {table}',
    })

"""
This function displays the contents of any table in the endangered monuments DBMS.

-> If someone visits /display/monument, then table_name will equal "monument"
-> If someone visits /display/researcher, then table_name will equal "researcher"
-> If someone visits /display/excavation_project, then table_name will equal "excavation_project".

This function is called when someone visits any of the following URLs:
1. http://localhost:3306/display/monument
2. http://localhost:3306/display/researcher
3. http://localhost:3306/display/excavation_project

More to be added.

Returns:
    returns a rendered HTML template with the table data
"""
@app.route('/display/<table_name>')
def display_table(table_name):
    """Display all records from the specified table"""
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)
    
    ## --------------- Query the DBMS --------------- ##
    
    # Get table columns
    cursor.execute(f"SHOW COLUMNS FROM {table_name}")
    columns = [column['Field'] for column in cursor.fetchall()]
    
    # Get table data
    cursor.execute(f"SELECT * FROM {table_name}")
    records = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return render_template('display_table.html', 
                          table_name=table_name,
                          columns=columns, 
                          records=records)

@app.route('/status')
def status():
    try:
        conn = mysql.connector.connect(**config)
        cursor = conn.cursor()
        cursor.execute("DESCRIBE MONUMENT") 
        columns = cursor.fetchall()
        column_names = [col[0] for col in columns]
        return jsonify(connected=True, columns=column_names)
    except Error as e:
        print("Database connection error:", e)
        return jsonify(connected=False, columns=[])
    finally:
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()

if __name__ == '__main__':
    app.run(debug=True)