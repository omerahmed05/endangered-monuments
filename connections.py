from flask import Flask, render_template, request, redirect, url_for, jsonify
import mysql.connector
from mysql.connector import Error

"""
When this program is ran using python connections.py, flask starts a web server that listens for requests.
"""
app = Flask(__name__)

config = {
    'host': 'localhost',
    'port': 3306,
    'user': 'root',
    'password': 'CS4604',
    'database': 'endangered_monuments'
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
@app.route('/add', methods=['POST'])
def add():
    data = request.form['data']
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor()
    # Just an example of how to insert data into the database
    cursor.execute("INSERT INTO monuments (URL) VALUES (%s)", (data,))
    conn.commit()
    cursor.close()
    conn.close()
    return redirect(url_for('index'))


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
        cursor.execute("DESCRIBE monuments") 
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