from flask import Flask, render_template, request, redirect, url_for, jsonify, session, flash, abort
import mysql.connector
from mysql.connector import Error
from werkzeug.security import generate_password_hash, check_password_hash
import os
import json

"""
When this program is ran using python connections.py, flask starts a web server that listens for requests.
"""
app = Flask(__name__)
app.secret_key = 'a-very-secret-key'
app.config['SESSION_PERMANENT'] = False
# Load your JSON file exactly once
HERE = os.path.dirname(__file__)
with open(os.path.join(HERE, 'login.JSON'), 'r') as f:
    raw = json.load(f)

# Normalize the keys to lowercase so 'Researcher' or 'researcher' both match
SIGNUP_FIELDS = { k.lower(): v for k, v in raw.items() }

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
    # Guests get the public guest home
    if 'user_id' not in session:
        return redirect(url_for('guest_home'))
    # Everyone else sees the same index page
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

@app.route('/signup/<role>', methods=['GET','POST'])
def signup(role):
    # 1) normalize incoming role
    role = role.lower()
    if role not in SIGNUP_FIELDS:
        abort(404)

    if request.method == 'POST':
        data = {}
        for field in SIGNUP_FIELDS[role]:
            # only gather fields the form actually shows you
            if not field.get('display', True):
                continue

            val = request.form.get(field['name'], '').strip()
            if field.get('required') and not val:
                flash(f"{field['name']} is required", "error")
                return redirect(request.url)
            data[field['name']] = val

        # hash the password (only if present)
        if 'PASSWORD' in data:
            data['PASSWORD'] = generate_password_hash(
                data['PASSWORD'],
                method='pbkdf2:sha256'
            )

        # 2) map role to a concrete table name
        if role == 'researcher':
            table_name = 'RESEARCHER'
        elif role == 'archaeologist':
            table_name = 'ARCHAEOLOGIST'
        else:
            abort(400)

        # 3) build & execute the INSERT
        cols = ", ".join(data.keys())
        placeholders = ", ".join(["%s"] * len(data))
        sql = f"INSERT INTO {table_name} ({cols}) VALUES ({placeholders})"

        conn = mysql.connector.connect(**config)
        cursor = conn.cursor(buffered=True)   # buffered to avoid unread‐result errors
        cursor.execute(sql, list(data.values()))
        conn.commit()
        cursor.close()
        conn.close()

        flash("Signup successful! Please log in.", "success")
        return redirect(url_for('login'))

    # GET → render the signup form
    return render_template('signup.html',
                           role=role,
                           fields=SIGNUP_FIELDS[role])

@app.route('/login', methods=['GET','POST'])
def login():
    print("xx")
    if request.method == 'POST':
        session.permanent = False
        role     = request.form.get('role', '').lower()
        username = request.form.get('USERNAME')
        password = request.form.get('PASSWORD')

        if role not in SIGNUP_FIELDS:
            flash("Invalid role.", "error")
            return redirect(url_for('login'))

        table = role.upper()
        #print(table)
        conn = mysql.connector.connect(**config)
        cursor = conn.cursor(dictionary=True)
        cursor.execute(f"SELECT * FROM {table} WHERE USERNAME=%s", (username,))
        user = cursor.fetchone()
        #print(cursor)
        print(user)
        print(user['PASSWORD'])
        cursor.close()
        conn.close()
        #print(password)
        print(check_password_hash(user['PASSWORD'], password))
        if user and check_password_hash(user['PASSWORD'], password):
            session['user_id'] = user[f"{table}_ID"]
            session['role']    = role
            flash("Logged in successfully.", "success")
            return redirect(url_for('index'))
        else:
            flash("Invalid credentials.", "error")
            return redirect(url_for('login'))

    return render_template('login.html')

@app.route('/change_password', methods=['GET','POST'])
def change_password():
    # 1) ensure the user is logged in
    if 'user_id' not in session:
        flash("You must be logged in to change your password", "error")
        return redirect(url_for('login'))

    if request.method == 'POST':
        old_pw     = request.form.get('old_password')
        new_pw     = request.form.get('new_password')
        confirm_pw = request.form.get('confirm_password')

        # 2) basic form validation
        if not old_pw or not new_pw or not confirm_pw:
            flash("All fields are required", "error")
            return redirect(request.url)
        if new_pw != confirm_pw:
            flash("New password and confirmation do not match", "error")
            return redirect(request.url)

        # 3) fetch the user’s current hash from the DB
        conn = mysql.connector.connect(**config)
        cursor = conn.cursor(dictionary=True)
        cursor.execute(
            "SELECT PASSWORD FROM {} WHERE {}_ID = %s"
            .format(session['role'].upper(), session['role'].upper()),
            (session['user_id'],)
        )
        user = cursor.fetchone()
        cursor.close()

        # 4) verify old password
        if not user or not check_password_hash(user['PASSWORD'], old_pw):
            flash("Old password is incorrect", "error")
            return redirect(request.url)

        # 5) hash and store the new password
        new_hash = generate_password_hash(new_pw, method='pbkdf2:sha256')
        conn = mysql.connector.connect(**config)
        cursor = conn.cursor()
        cursor.execute(
            "UPDATE {} SET PASSWORD = %s WHERE {}_ID = %s"
            .format(session['role'].upper(), session['role'].upper()),
            (new_hash, session['user_id'])
        )
        conn.commit()
        cursor.close()
        conn.close()

        flash("Your password has been updated!", "success")
        return redirect(url_for('index'))

    # GET → render a simple form
    return render_template('change_password.html')

from flask import session, redirect, url_for, flash

@app.route('/logout')
def logout():
    # 1) Remove any user info from the session
    session.pop('user_id', None)
    session.pop('role',    None)
    # 2) Give a quick message
    flash("You have been logged out.", "success")
    # 3) Send them back home (or to your login page)
    return redirect(url_for('index'))

@app.route('/create_admin', methods=['GET','POST'])
def create_admin():
    # only archaeologist-admins allowed
    if session.get('role') != 'archaeologist':
        abort(403)

    # forward to your signup view with role='archaeologist'
    return signup('archaeologist')

@app.route('/manager_view')
def manager_view():
    if session.get('role') != 'archaeologist':
        abort(403)

    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM RESEARCHER")
    researchers = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('manager_view.html',
                           researchers=researchers)

@app.route('/edit_researcher/<int:researcher_id>', methods=['GET','POST'])
def edit_researcher(researcher_id):
    if session.get('role') != 'archaeologist':
        abort(403)

    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)

    if request.method == 'POST':
        # build update from form
        data = { key: request.form[key]
                 for key in request.form
                 if key != 'RESEARCHER_ID' }
        cols = ", ".join(f"{k}=%s" for k in data)
        vals = list(data.values()) + [researcher_id]
        sql = f"UPDATE RESEARCHER SET {cols} WHERE RESEARCHER_ID = %s"
        cursor.execute(sql, vals)
        conn.commit()
        flash("Researcher updated", "success")
        cursor.close()
        conn.close()
        return redirect(url_for('manager_view'))

    # GET: fetch record and columns
    cursor.execute("SHOW COLUMNS FROM RESEARCHER")
    columns = [c['Field'] for c in cursor.fetchall()]
    cursor.execute(
        "SELECT * FROM RESEARCHER WHERE RESEARCHER_ID = %s",
        (researcher_id,)
    )
    researcher = cursor.fetchone()
    cursor.close()
    conn.close()

    return render_template('edit_researcher.html',
                           researcher=researcher,
                           columns=columns)

@app.route('/guest')
def guest_home():
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
      SELECT
        m.MONUMENT_ID,
        m.NAME               AS monument_name,
        m.ITEM_CATEGORY,
        m.THUMBNAIL,
        c.NAME               AS city_name,        -- added
        p.NAME               AS project_name,
        GROUP_CONCAT(r.USERNAME SEPARATOR ', ')
          AS researcher_names
      FROM MONUMENT m

      JOIN CITY c
        ON m.CITY_ID = c.CITY_ID                -- join CITY

      JOIN EXCAVATION_PROJECT p
        ON m.EXCAVATION_ID = p.EXCAVATION_ID    -- join PROJECT

      LEFT JOIN RESEARCHER r
        ON m.EXCAVATION_ID = r.EXCAVATION_ID

      GROUP BY
        m.MONUMENT_ID,
        m.NAME,
        m.ITEM_CATEGORY,
        m.THUMBNAIL,
        c.NAME,                                  -- include city in GROUP BY
        p.NAME

      ORDER BY m.MONUMENT_ID;
    """)
    monuments = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template('guest_home.html', monuments=monuments)

@app.route('/monument/<int:monument_id>')
def monument_detail(monument_id):
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
      SELECT
        m.MONUMENT_ID,
        m.NAME               AS monument_name,
        m.ITEM_CATEGORY,
        m.THUMBNAIL,
        m.LATITUDE,
        m.LONGITUDE,
        c.NAME               AS city_name,
        p.NAME               AS project_name,        -- new column
        GROUP_CONCAT(r.USERNAME SEPARATOR ', ') 
          AS researcher_names
      FROM MONUMENT m
      JOIN CITY c
        ON m.CITY_ID = c.CITY_ID
      JOIN EXCAVATION_PROJECT p
        ON m.EXCAVATION_ID = p.EXCAVATION_ID  -- join to get project
      LEFT JOIN RESEARCHER r
        ON m.EXCAVATION_ID = r.EXCAVATION_ID
      WHERE m.MONUMENT_ID = %s
      GROUP BY
        m.MONUMENT_ID,
        m.NAME,
        m.ITEM_CATEGORY,
        m.THUMBNAIL,
        m.LATITUDE,
        m.LONGITUDE,
        c.NAME,
        p.NAME
    """, (monument_id,))
    mon = cursor.fetchone()
    cursor.close()
    conn.close()

    if not mon:
        abort(404)
    return render_template('monument_detail.html', monument=mon)

@app.route('/excavations')
def guest_excavations():
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)
    cursor.execute("""
      SELECT
        p.EXCAVATION_ID,
        p.NAME           AS project_name,
        p.PROJECT_URL,
        c.NAME           AS city_name
      FROM EXCAVATION_PROJECT p
      JOIN CITY c ON p.CITY_ID = c.CITY_ID
      ORDER BY p.EXCAVATION_ID;
    """)
    projects = cursor.fetchall()
    cursor.close()
    conn.close()
    return render_template('guest_excavations.html', projects=projects)


@app.route('/excavation/<int:excavation_id>')
def excavation_detail(excavation_id):
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)

    # First, get the project’s own name
    cursor.execute(
      "SELECT NAME AS project_name FROM EXCAVATION_PROJECT WHERE EXCAVATION_ID = %s",
      (excavation_id,)
    )
    proj = cursor.fetchone()
    project_name = proj['project_name'] if proj else 'Excavation'

    # Then fetch its monuments
    cursor.execute("""
      SELECT
        m.MONUMENT_ID,
        m.NAME            AS monument_name,
        m.ITEM_CATEGORY,
        m.THUMBNAIL,
        c.NAME            AS city_name,
        GROUP_CONCAT(r.USERNAME SEPARATOR ', ')
          AS researcher_names
      FROM MONUMENT m
      JOIN CITY c ON m.CITY_ID = c.CITY_ID
      LEFT JOIN RESEARCHER r
        ON m.EXCAVATION_ID = r.EXCAVATION_ID
      WHERE m.EXCAVATION_ID = %s
      GROUP BY
        m.MONUMENT_ID, m.NAME, m.ITEM_CATEGORY,
        m.THUMBNAIL, c.NAME
      ORDER BY m.MONUMENT_ID;
    """, (excavation_id,))

    monuments = cursor.fetchall()
    cursor.close()
    conn.close()

    return render_template(
      'excavation_detail.html',
      monuments=monuments,
      project_name=project_name
    )
@app.route('/statistics')
def statistics():
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)

    # Totals
    cursor.execute("SELECT COUNT(*) AS total_monuments FROM MONUMENT")
    total_monuments = cursor.fetchone()['total_monuments']
    cursor.execute("SELECT COUNT(*) AS total_researchers FROM RESEARCHER")
    total_researchers = cursor.fetchone()['total_researchers']
    cursor.execute("SELECT COUNT(*) AS total_archaeologists FROM ARCHAEOLOGIST")
    total_archaeologists = cursor.fetchone()['total_archaeologists']
    cursor.execute("SELECT COUNT(*) AS total_projects FROM EXCAVATION_PROJECT")
    total_projects = cursor.fetchone()['total_projects']

    # Breakdown: monuments by category
    cursor.execute("""
      SELECT ITEM_CATEGORY AS category, COUNT(*) AS count
      FROM MONUMENT
      GROUP BY ITEM_CATEGORY
    """)
    monos_by_category = cursor.fetchall()

    # Breakdown: monuments by city
    cursor.execute("""
      SELECT c.NAME AS city, COUNT(m.MONUMENT_ID) AS count
      FROM MONUMENT m
      JOIN CITY c ON m.CITY_ID = c.CITY_ID
      GROUP BY c.NAME
    """)
    monos_by_city = cursor.fetchall()

    # Breakdown: researchers per excavation project
    cursor.execute("""
      SELECT p.NAME AS project, COUNT(r.RESEARCHER_ID) AS count
      FROM EXCAVATION_PROJECT p
      LEFT JOIN RESEARCHER r
        ON p.EXCAVATION_ID = r.EXCAVATION_ID
      GROUP BY p.NAME
    """)
    researchers_per_project = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template('statistics.html',
                           total_monuments=total_monuments,
                           total_researchers=total_researchers,
                           total_archaeologists=total_archaeologists,
                           total_projects=total_projects,
                           monos_by_category=monos_by_category,
                           monos_by_city=monos_by_city,
                           researchers_per_project=researchers_per_project)

if __name__ == '__main__':
    #print(app.url_map)
    app.run(debug=True)