from flask import Flask, render_template, request, redirect, url_for, jsonify, session, flash, abort, make_response


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
    
    # Redirect based on role
    if session.get('role') == 'archaeologist':
        return redirect(url_for('archaeologist_home'))
    elif session.get('role') == 'researcher':
        return redirect(url_for('researcher_home'))
    
    return redirect(url_for('guest_home'))

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
            # Add EXCAVATION_ID and MANAGER to data
            data['EXCAVATION_ID'] = request.form.get('EXCAVATION_ID')
            data['MANAGER'] = request.form.get('MANAGER')
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
    # Fetch excavation projects and managers for dropdowns
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)
    
    # Fetch excavation projects
    cursor.execute("SELECT EXCAVATION_ID, NAME FROM EXCAVATION_PROJECT")
    excavation_projects = cursor.fetchall()
    
    # Fetch managers (archaeologists who are managers)
    cursor.execute("""
        SELECT a.ARCHAEOLOGIST_ID, a.USERNAME 
        FROM ARCHAEOLOGIST a
        WHERE a.ARCHAEOLOGIST_ID IN (
            SELECT DISTINCT r.MANAGER 
            FROM RESEARCHER r 
            WHERE r.MANAGER IS NOT NULL
        )
    """)
    managers = cursor.fetchall()
    
    cursor.close()
    conn.close()

    return render_template('signup.html',
                           role=role,
                           fields=SIGNUP_FIELDS[role],
                           excavation_projects=excavation_projects,
                           managers=managers)

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

        # 3) fetch the user's current hash from the DB
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
    
    # Get total counts for statistics
    cursor.execute("SELECT COUNT(*) AS count FROM MONUMENT")
    total_monuments = cursor.fetchone()['count']
    
    cursor.execute("SELECT COUNT(*) AS count FROM EXCAVATION_PROJECT")
    total_projects = cursor.fetchone()['count']
    
    cursor.execute("SELECT COUNT(*) AS count FROM CITY")
    total_cities = cursor.fetchone()['count']
    
    cursor.execute("SELECT COUNT(*) AS count FROM RESEARCHER")
    total_researchers = cursor.fetchone()['count']
    
    cursor.close()
    conn.close()
    
    return render_template('guest_home.html',
                         total_monuments=total_monuments,
                         total_projects=total_projects,
                         total_cities=total_cities,
                         total_researchers=total_researchers)

@app.route('/monuments')
def monuments():
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("""
      SELECT
        m.MONUMENT_ID,
        m.NAME               AS monument_name,
        m.ITEM_CATEGORY,
        m.THUMBNAIL,
        c.NAME               AS city_name,
        p.NAME               AS project_name,
        GROUP_CONCAT(r.USERNAME SEPARATOR ', ')
          AS researcher_names
      FROM MONUMENT m
      JOIN CITY c ON m.CITY_ID = c.CITY_ID
      JOIN EXCAVATION_PROJECT p ON m.EXCAVATION_ID = p.EXCAVATION_ID
      LEFT JOIN RESEARCHER r ON m.EXCAVATION_ID = r.EXCAVATION_ID
      GROUP BY
        m.MONUMENT_ID,
        m.NAME,
        m.ITEM_CATEGORY,
        m.THUMBNAIL,
        c.NAME,
        p.NAME
      ORDER BY m.MONUMENT_ID
    """)
    monuments = cursor.fetchall()
    cursor.close()
    conn.close()
    
    return render_template('monuments.html', monuments=monuments)

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
        m.CONDITION_NOTES,
        c.NAME               AS city_name,
        p.NAME               AS project_name,
        GROUP_CONCAT(r.USERNAME SEPARATOR ', ') 
          AS researcher_names
      FROM MONUMENT m
      JOIN CITY c
        ON m.CITY_ID = c.CITY_ID
      JOIN EXCAVATION_PROJECT p
        ON m.EXCAVATION_ID = p.EXCAVATION_ID
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
        m.CONDITION_NOTES,
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

    # First, get the project's own name
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

    # Get total counts
    cursor.execute("SELECT COUNT(*) as total_monuments FROM MONUMENT")
    total_monuments = cursor.fetchone()['total_monuments']
    
    cursor.execute("SELECT COUNT(*) as total_projects FROM EXCAVATION_PROJECT")
    total_projects = cursor.fetchone()['total_projects']
    
    cursor.execute("SELECT COUNT(*) as total_cities FROM CITY")
    total_cities = cursor.fetchone()['total_cities']
    
    cursor.execute("SELECT COUNT(*) as total_researchers FROM RESEARCHER")
    total_researchers = cursor.fetchone()['total_researchers']

    # Monuments by Category with percentages
    cursor.execute("""
        SELECT 
            ITEM_CATEGORY as category,
            COUNT(*) as count,
            ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM MONUMENT), 1) as percentage
        FROM MONUMENT
        GROUP BY ITEM_CATEGORY
        ORDER BY count DESC
    """)
    monos_by_category = cursor.fetchall()

    # Monuments by City with percentages
    cursor.execute("""
        SELECT 
            c.NAME as city,
            COUNT(m.MONUMENT_ID) as count,
            ROUND(COUNT(m.MONUMENT_ID) * 100.0 / (SELECT COUNT(*) FROM MONUMENT), 1) as percentage
        FROM CITY c
        LEFT JOIN MONUMENT m ON c.CITY_ID = m.CITY_ID
        GROUP BY c.CITY_ID, c.NAME
        ORDER BY count DESC
    """)
    monos_by_city = cursor.fetchall()

    # Researchers per Project with percentages
    cursor.execute("""
        SELECT 
            p.NAME as project,
            COUNT(DISTINCT r.RESEARCHER_ID) as count,
            ROUND(COUNT(DISTINCT r.RESEARCHER_ID) * 100.0 / (SELECT COUNT(*) FROM RESEARCHER), 1) as percentage
        FROM EXCAVATION_PROJECT p
        LEFT JOIN RESEARCHER r ON p.EXCAVATION_ID = r.EXCAVATION_ID
        GROUP BY p.EXCAVATION_ID, p.NAME
        ORDER BY count DESC
    """)
    researchers_per_project = cursor.fetchall()

    cursor.close()
    conn.close()

    return render_template('statistics.html',
                         total_monuments=total_monuments,
                         total_projects=total_projects,
                         total_cities=total_cities,
                         total_researchers=total_researchers,
                         monos_by_category=monos_by_category,
                         monos_by_city=monos_by_city,
                         researchers_per_project=researchers_per_project)

@app.route('/admin_statistics')
def admin_statistics():
    # only archaeologist-admins allowed
    if session.get('role') != 'archaeologist':
        abort(403)

    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)

    # 1. Basic Counts and Averages
    cursor.execute("""
        SELECT 
            (SELECT COUNT(*) FROM ARCHAEOLOGIST) AS total_archaeologists,
            (SELECT COUNT(*) FROM EXCAVATION_PROJECT) AS total_projects,
            (SELECT COUNT(*) FROM CITY) AS total_cities,
            (SELECT COUNT(*) FROM MONUMENT) AS total_monuments,
            (SELECT COUNT(*) FROM RESEARCHER) AS total_researchers,
            (SELECT AVG(monument_count) FROM (
                SELECT COUNT(m.MONUMENT_ID) AS monument_count
                FROM EXCAVATION_PROJECT p
                LEFT JOIN MONUMENT m ON p.EXCAVATION_ID = m.EXCAVATION_ID
                GROUP BY p.EXCAVATION_ID
            ) AS project_counts) AS avg_monuments_per_project
    """)
    basic_stats = cursor.fetchone()

    # 2. Project Statistics
    cursor.execute("""
        SELECT 
            p.NAME AS project_name,
            COUNT(m.MONUMENT_ID) AS monument_count,
            COUNT(r.RESEARCHER_ID) AS researcher_count,
            MIN(m.LATITUDE) AS min_latitude,
            MAX(m.LATITUDE) AS max_latitude,
            MIN(m.LONGITUDE) AS min_longitude,
            MAX(m.LONGITUDE) AS max_longitude
        FROM EXCAVATION_PROJECT p
        LEFT JOIN MONUMENT m ON p.EXCAVATION_ID = m.EXCAVATION_ID
        LEFT JOIN RESEARCHER r ON p.EXCAVATION_ID = r.EXCAVATION_ID
        GROUP BY p.EXCAVATION_ID, p.NAME
        ORDER BY monument_count DESC
    """)
    project_stats = cursor.fetchall()

    # 3. City-wise Statistics
    cursor.execute("""
        SELECT 
            c.NAME AS city_name,
            COUNT(DISTINCT p.EXCAVATION_ID) AS project_count,
            COUNT(DISTINCT m.MONUMENT_ID) AS monument_count,
            COUNT(DISTINCT r.RESEARCHER_ID) AS researcher_count,
            SUM(CASE WHEN m.CONDITION_NOTES IS NOT NULL THEN 1 ELSE 0 END) AS documented_monuments
        FROM CITY c
        LEFT JOIN EXCAVATION_PROJECT p ON c.CITY_ID = p.CITY_ID
        LEFT JOIN MONUMENT m ON p.EXCAVATION_ID = m.EXCAVATION_ID
        LEFT JOIN RESEARCHER r ON p.EXCAVATION_ID = r.EXCAVATION_ID
        GROUP BY c.CITY_ID, c.NAME
        ORDER BY monument_count DESC
    """)
    city_stats = cursor.fetchall()

    # 4. Monument Category Statistics
    cursor.execute("""
        SELECT 
            ITEM_CATEGORY,
            COUNT(*) AS count,
            MIN(LATITUDE) AS min_latitude,
            MAX(LATITUDE) AS max_latitude,
            MIN(LONGITUDE) AS min_longitude,
            MAX(LONGITUDE) AS max_longitude,
            AVG(LATITUDE) AS avg_latitude,
            AVG(LONGITUDE) AS avg_longitude
        FROM MONUMENT
        GROUP BY ITEM_CATEGORY
        ORDER BY count DESC
    """)
    category_stats = cursor.fetchall()

    # 5. Researcher Performance Metrics
    cursor.execute("""
        SELECT 
            p.NAME as project_name,
            COUNT(DISTINCT r.RESEARCHER_ID) as researcher_count,
            CASE 
                WHEN COUNT(DISTINCT r.RESEARCHER_ID) = 0 THEN 0
                ELSE ROUND(COUNT(m.MONUMENT_ID) * 1.0 / COUNT(DISTINCT r.RESEARCHER_ID), 1)
            END as monuments_per_researcher
        FROM EXCAVATION_PROJECT p
        LEFT JOIN RESEARCHER r ON p.EXCAVATION_ID = r.EXCAVATION_ID
        LEFT JOIN MONUMENT m ON p.EXCAVATION_ID = m.EXCAVATION_ID
        GROUP BY p.EXCAVATION_ID, p.NAME
        ORDER BY researcher_count DESC
    """)
    researcher_activity = cursor.fetchall()

    # Calculate researcher summary statistics
    cursor.execute("""
        SELECT 
            (SELECT COUNT(DISTINCT r.RESEARCHER_ID) FROM RESEARCHER r) as total_researchers,
            AVG(rc.researcher_count) as avg_researchers_per_project,
            (SELECT p.NAME 
             FROM EXCAVATION_PROJECT p
             LEFT JOIN RESEARCHER r ON p.EXCAVATION_ID = r.EXCAVATION_ID
             GROUP BY p.EXCAVATION_ID, p.NAME
             ORDER BY COUNT(DISTINCT r.RESEARCHER_ID) DESC
             LIMIT 1) as project_with_most_researchers
        FROM (
            SELECT p.EXCAVATION_ID, COUNT(DISTINCT r.RESEARCHER_ID) as researcher_count
            FROM EXCAVATION_PROJECT p
            LEFT JOIN RESEARCHER r ON p.EXCAVATION_ID = r.EXCAVATION_ID
            GROUP BY p.EXCAVATION_ID
        ) AS rc
    """)
    researcher_stats = cursor.fetchone()
    total_researchers = researcher_stats['total_researchers']
    avg_researchers_per_project = researcher_stats['avg_researchers_per_project'] or 0
    project_with_most_researchers = researcher_stats['project_with_most_researchers']

    # Monument Documentation
    cursor.execute("""
        SELECT 
            CASE 
                WHEN m.CONDITION_NOTES IS NULL OR m.CONDITION_NOTES = '' THEN 'Not Documented'
                ELSE 'Documented'
            END as status,
            COUNT(*) as count,
            ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM MONUMENT), 1) as percentage
        FROM MONUMENT m
        GROUP BY status
    """)
    documentation_status = cursor.fetchall()

    # Calculate documentation summary statistics
    cursor.execute("""
        SELECT 
            COUNT(*) as total_documented,
            ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM MONUMENT), 1) as documentation_rate,
            AVG(LENGTH(m.CONDITION_NOTES)) as avg_notes_length
        FROM MONUMENT m
        WHERE m.CONDITION_NOTES IS NOT NULL AND m.CONDITION_NOTES != ''
    """)
    doc_stats = cursor.fetchone()
    total_documented = doc_stats['total_documented']
    documentation_rate = doc_stats['documentation_rate'] or 0
    avg_notes_length = doc_stats['avg_notes_length'] or 0

    cursor.close()
    conn.close()

    return render_template(
        'admin_statistics.html',
        basic_stats=basic_stats,
        project_stats=project_stats,
        city_stats=city_stats,
        category_stats=category_stats,
        researcher_activity=researcher_activity,
        total_researchers=total_researchers,
        avg_researchers_per_project=avg_researchers_per_project,
        project_with_most_researchers=project_with_most_researchers,
        documentation_status=documentation_status,
        total_documented=total_documented,
        documentation_rate=documentation_rate,
        avg_notes_length=avg_notes_length
    )

@app.route('/researcher')
def researcher_home():
    if session.get('role') != 'researcher':
        abort(403)
    
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)
    
    # Get monuments with their details
    cursor.execute("""
      SELECT
        m.MONUMENT_ID,
        m.NAME               AS monument_name,
        m.ITEM_CATEGORY,
        m.THUMBNAIL,
        c.NAME               AS city_name,
        p.NAME               AS project_name,
        GROUP_CONCAT(r.USERNAME SEPARATOR ', ')
          AS researcher_names
      FROM MONUMENT m
      JOIN CITY c ON m.CITY_ID = c.CITY_ID
      JOIN EXCAVATION_PROJECT p ON m.EXCAVATION_ID = p.EXCAVATION_ID
      LEFT JOIN RESEARCHER r ON m.EXCAVATION_ID = r.EXCAVATION_ID
      GROUP BY
        m.MONUMENT_ID,
        m.NAME,
        m.ITEM_CATEGORY,
        m.THUMBNAIL,
        c.NAME,
        p.NAME
      ORDER BY m.MONUMENT_ID
    """)
    monuments = cursor.fetchall()
    cursor.close()
    conn.close()
    
    return render_template('researcher_home.html', monuments=monuments)

@app.route('/archaeologist')
def archaeologist_home():
    if session.get('role') != 'archaeologist':
        abort(403)
    
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)
    
    # Get recent monuments
    cursor.execute("""
      SELECT
        m.MONUMENT_ID,
        m.NAME AS monument_name,
        c.NAME AS city_name,
        p.NAME AS project_name
      FROM MONUMENT m
      JOIN CITY c ON m.CITY_ID = c.CITY_ID
      JOIN EXCAVATION_PROJECT p ON m.EXCAVATION_ID = p.EXCAVATION_ID
      ORDER BY m.MONUMENT_ID DESC
      LIMIT 5
    """)
    recent_monuments = cursor.fetchall()
    
    # Get recent researchers
    cursor.execute("""
      SELECT RESEARCHER_ID, USERNAME, START_DATE
      FROM RESEARCHER
      ORDER BY START_DATE DESC
      LIMIT 5
    """)
    recent_researchers = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return render_template('archaeologist_home.html',
                         recent_monuments=recent_monuments,
                         recent_researchers=recent_researchers)

@app.route('/api/bookmark', methods=['POST', 'DELETE'])
def bookmark_monument():
    if session.get('role') != 'researcher':
        abort(403)
    
    data = request.json
    monument_id = data.get('monument_id')
    researcher_id = session.get('user_id')
    
    if not monument_id or not researcher_id:
        return jsonify({'success': False, 'message': 'Missing required data'})
    
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor()
    
    try:
        if request.method == 'POST':
            # Check if bookmark already exists
            cursor.execute("""
                SELECT 1 FROM BOOKMARK 
                WHERE RESEARCHER_ID = %s AND MONUMENT_ID = %s
            """, (researcher_id, monument_id))
            if cursor.fetchone():
                return jsonify({'success': False, 'message': 'Monument already bookmarked'})
            
            # Add new bookmark
            cursor.execute("""
                INSERT INTO BOOKMARK (RESEARCHER_ID, MONUMENT_ID)
                VALUES (%s, %s)
            """, (researcher_id, monument_id))
            message = 'Bookmark added successfully'
        else:  # DELETE
            cursor.execute("""
                DELETE FROM BOOKMARK 
                WHERE RESEARCHER_ID = %s AND MONUMENT_ID = %s
            """, (researcher_id, monument_id))
            message = 'Bookmark removed successfully'
        
        conn.commit()
        return jsonify({'success': True, 'message': message})
    except mysql.connector.Error as err:
        return jsonify({'success': False, 'message': str(err)})
    finally:
        cursor.close()
        conn.close()

@app.route('/api/export', methods=['POST'])
def export_monument():
    if session.get('role') != 'researcher':
        abort(403)
    
    data = request.json
    monument_id = data.get('monument_id')
    
    if not monument_id:
        return jsonify({'success': False, 'message': 'Missing monument ID'})
    
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)
    
    try:
        cursor.execute("""
            SELECT
                m.*,
                c.NAME AS city_name,
                p.NAME AS project_name,
                GROUP_CONCAT(r.USERNAME SEPARATOR ', ') AS researcher_names
            FROM MONUMENT m
            JOIN CITY c ON m.CITY_ID = c.CITY_ID
            JOIN EXCAVATION_PROJECT p ON m.EXCAVATION_ID = p.EXCAVATION_ID
            LEFT JOIN RESEARCHER r ON m.EXCAVATION_ID = r.EXCAVATION_ID
            WHERE m.MONUMENT_ID = %s
            GROUP BY m.MONUMENT_ID
        """, (monument_id,))
        
        monument_data = cursor.fetchone()
        if not monument_data:
            return jsonify({'success': False, 'message': 'Monument not found'})
        
        # Convert to JSON and return as file
        response = make_response(json.dumps(monument_data, indent=2))
        response.headers['Content-Type'] = 'application/json'
        response.headers['Content-Disposition'] = f'attachment; filename=monument_{monument_id}_data.json'
        return response
    except mysql.connector.Error as err:
        return jsonify({'success': False, 'message': str(err)})
    finally:
        cursor.close()
        conn.close()

@app.route('/my_bookmarks')
def my_bookmarks():
    if session.get('role') != 'researcher':
        abort(403)
    
    researcher_id = session.get('user_id')
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)
    
    cursor.execute("""
        SELECT
            m.MONUMENT_ID,
            m.NAME AS monument_name,
            m.ITEM_CATEGORY,
            m.THUMBNAIL,
            c.NAME AS city_name,
            p.NAME AS project_name,
            GROUP_CONCAT(r.USERNAME SEPARATOR ', ') AS researcher_names
        FROM BOOKMARK b
        JOIN MONUMENT m ON b.MONUMENT_ID = m.MONUMENT_ID
        JOIN CITY c ON m.CITY_ID = c.CITY_ID
        JOIN EXCAVATION_PROJECT p ON m.EXCAVATION_ID = p.EXCAVATION_ID
        LEFT JOIN RESEARCHER r ON m.EXCAVATION_ID = r.EXCAVATION_ID
        WHERE b.RESEARCHER_ID = %s
        GROUP BY m.MONUMENT_ID
        ORDER BY m.MONUMENT_ID
    """, (researcher_id,))
    
    bookmarks = cursor.fetchall()
    cursor.close()
    conn.close()
    
    return render_template('my_bookmarks.html', bookmarks=bookmarks)

@app.route('/manage_monuments')
def manage_monuments():
    if session.get('role') != 'archaeologist':
        abort(403)
    
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)
    
    # Get all monuments with their details
    cursor.execute("""
        SELECT
            m.MONUMENT_ID,
            m.NAME AS monument_name,
            m.ITEM_CATEGORY,
            m.THUMBNAIL,
            m.LATITUDE,
            m.LONGITUDE,
            c.NAME AS city_name,
            p.NAME AS project_name,
            GROUP_CONCAT(r.USERNAME SEPARATOR ', ') AS researcher_names
        FROM MONUMENT m
        JOIN CITY c ON m.CITY_ID = c.CITY_ID
        JOIN EXCAVATION_PROJECT p ON m.EXCAVATION_ID = p.EXCAVATION_ID
        LEFT JOIN RESEARCHER r ON m.EXCAVATION_ID = r.EXCAVATION_ID
        GROUP BY m.MONUMENT_ID
        ORDER BY m.MONUMENT_ID
    """)
    monuments = cursor.fetchall()
    
    # Get all cities for the add monument form
    cursor.execute("SELECT CITY_ID, NAME FROM CITY ORDER BY NAME")
    cities = cursor.fetchall()
    
    # Get all excavation projects for the add monument form
    cursor.execute("SELECT EXCAVATION_ID, NAME FROM EXCAVATION_PROJECT ORDER BY NAME")
    projects = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return render_template('manage_monuments.html',
                         monuments=monuments,
                         cities=cities,
                         projects=projects)

@app.route('/api/monument', methods=['POST', 'PUT', 'DELETE'])
def handle_monument():
    if session.get('role') != 'archaeologist':
        abort(403)
    
    data = request.json
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor()
    
    try:
        if request.method == 'POST':
            # Add new monument
            cursor.execute("""
                INSERT INTO MONUMENT (
                    NAME, ITEM_CATEGORY, THUMBNAIL, LATITUDE, LONGITUDE,
                    CITY_ID, EXCAVATION_ID
                ) VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (
                data.get('name'),
                data.get('item_category'),
                data.get('thumbnail'),
                data.get('latitude'),
                data.get('longitude'),
                data.get('city_id'),
                data.get('excavation_id')
            ))
            message = 'Monument added successfully'
            
        elif request.method == 'PUT':
            # Update existing monument
            cursor.execute("""
                UPDATE MONUMENT SET
                    NAME = %s,
                    ITEM_CATEGORY = %s,
                    THUMBNAIL = %s,
                    LATITUDE = %s,
                    LONGITUDE = %s,
                    CITY_ID = %s,
                    EXCAVATION_ID = %s
                WHERE MONUMENT_ID = %s
            """, (
                data.get('name'),
                data.get('item_category'),
                data.get('thumbnail'),
                data.get('latitude'),
                data.get('longitude'),
                data.get('city_id'),
                data.get('excavation_id'),
                data.get('monument_id')
            ))
            message = 'Monument updated successfully'
            
        else:  # DELETE
            # Delete monument
            cursor.execute("""
                DELETE FROM MONUMENT WHERE MONUMENT_ID = %s
            """, (data.get('monument_id'),))
            message = 'Monument deleted successfully'
        
        conn.commit()
        return jsonify({'success': True, 'message': message})
        
    except mysql.connector.Error as err:
        return jsonify({'success': False, 'message': str(err)})
    finally:
        cursor.close()
        conn.close()

@app.route('/manage_projects')
def manage_projects():
    if session.get('role') != 'archaeologist':
        abort(403)
    
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)
    
    # Get all excavation projects with their details
    cursor.execute("""
        SELECT
            p.EXCAVATION_ID,
            p.NAME AS project_name,
            p.PROJECT_URL,
            c.NAME AS city_name,
            COUNT(m.MONUMENT_ID) AS monument_count,
            GROUP_CONCAT(r.USERNAME SEPARATOR ', ') AS researcher_names
        FROM EXCAVATION_PROJECT p
        JOIN CITY c ON p.CITY_ID = c.CITY_ID
        LEFT JOIN MONUMENT m ON p.EXCAVATION_ID = m.EXCAVATION_ID
        LEFT JOIN RESEARCHER r ON p.EXCAVATION_ID = r.EXCAVATION_ID
        GROUP BY p.EXCAVATION_ID
        ORDER BY p.EXCAVATION_ID
    """)
    projects = cursor.fetchall()
    
    # Get all cities for the add project form
    cursor.execute("SELECT CITY_ID, NAME FROM CITY ORDER BY NAME")
    cities = cursor.fetchall()
    
    cursor.close()
    conn.close()
    
    return render_template('manage_projects.html',
                         projects=projects,
                         cities=cities)

@app.route('/api/project', methods=['POST', 'PUT', 'DELETE'])
def handle_project():
    if session.get('role') != 'archaeologist':
        abort(403)
    
    data = request.json
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor()
    
    try:
        if request.method == 'POST':
            # Add new project
            cursor.execute("""
                INSERT INTO EXCAVATION_PROJECT (
                    NAME, PROJECT_URL, CITY_ID
                ) VALUES (%s, %s, %s)
            """, (
                data.get('name'),
                data.get('project_url'),
                data.get('city_id')
            ))
            message = 'Project added successfully'
            
        elif request.method == 'PUT':
            # Update existing project
            cursor.execute("""
                UPDATE EXCAVATION_PROJECT SET
                    NAME = %s,
                    PROJECT_URL = %s,
                    CITY_ID = %s
                WHERE EXCAVATION_ID = %s
            """, (
                data.get('name'),
                data.get('project_url'),
                data.get('city_id'),
                data.get('excavation_id')
            ))
            message = 'Project updated successfully'
            
        else:  # DELETE
            # Delete project
            cursor.execute("""
                DELETE FROM EXCAVATION_PROJECT WHERE EXCAVATION_ID = %s
            """, (data.get('excavation_id'),))
            message = 'Project deleted successfully'
        
        conn.commit()
        return jsonify({'success': True, 'message': message})
        
    except mysql.connector.Error as err:
        return jsonify({'success': False, 'message': str(err)})
    finally:
        cursor.close()
        conn.close()

@app.route('/api/monument/notes', methods=['PUT'])
def update_monument_notes():
    if session.get('role') != 'archaeologist':
        abort(403)
    
    data = request.json
    monument_id = data.get('monument_id')
    condition_notes = data.get('condition_notes')
    
    if not monument_id:
        return jsonify({'success': False, 'message': 'Missing monument ID'})
    
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor()
    
    try:
        cursor.execute("""
            UPDATE MONUMENT 
            SET CONDITION_NOTES = %s 
            WHERE MONUMENT_ID = %s
        """, (condition_notes, monument_id))
        
        conn.commit()
        return jsonify({'success': True, 'message': 'Notes updated successfully'})
    except mysql.connector.Error as err:
        return jsonify({'success': False, 'message': str(err)})
    finally:
        cursor.close()
        conn.close()

@app.route('/researcher_statistics')
def researcher_statistics():
    if 'user_id' not in session or session.get('role') != 'researcher':
        return redirect(url_for('login'))
    
    conn = mysql.connector.connect(**config)
    cursor = conn.cursor(dictionary=True)

    # Project Distribution
    cursor.execute("""
        SELECT 
            p.NAME as project_name,
            COUNT(m.MONUMENT_ID) as monument_count,
            ROUND(COUNT(m.MONUMENT_ID) * 100.0 / (SELECT COUNT(*) FROM MONUMENT), 1) as percentage
        FROM EXCAVATION_PROJECT p
        LEFT JOIN MONUMENT m ON p.EXCAVATION_ID = m.EXCAVATION_ID
        GROUP BY p.EXCAVATION_ID, p.NAME
        ORDER BY monument_count DESC
    """)
    project_distribution = cursor.fetchall()

    # Calculate project summary statistics
    cursor.execute("""
        SELECT 
            COUNT(DISTINCT pc.EXCAVATION_ID) as total_projects,
            AVG(pc.monument_count) as avg_monuments_per_project,
            MAX(pc.monument_count) as max_monuments_in_project
        FROM (
            SELECT p.EXCAVATION_ID, COUNT(m.MONUMENT_ID) as monument_count
            FROM EXCAVATION_PROJECT p
            LEFT JOIN MONUMENT m ON p.EXCAVATION_ID = m.EXCAVATION_ID
            GROUP BY p.EXCAVATION_ID
        ) AS pc
    """)
    project_stats = cursor.fetchone()
    total_projects = project_stats['total_projects']
    avg_monuments_per_project = project_stats['avg_monuments_per_project'] or 0
    max_monuments_in_project = project_stats['max_monuments_in_project'] or 0

    # Category Analysis
    cursor.execute("""
        SELECT 
            m.ITEM_CATEGORY as category,
            COUNT(*) as count,
            ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM MONUMENT), 1) as percentage
        FROM MONUMENT m
        GROUP BY m.ITEM_CATEGORY
        ORDER BY count DESC
    """)
    category_distribution = cursor.fetchall()

    # Calculate category summary statistics
    cursor.execute("""
        SELECT 
            COUNT(DISTINCT m.ITEM_CATEGORY) as total_categories,
            m.ITEM_CATEGORY as most_common,
            (SELECT m2.ITEM_CATEGORY FROM MONUMENT m2 GROUP BY m2.ITEM_CATEGORY ORDER BY COUNT(*) ASC LIMIT 1) as least_common
        FROM MONUMENT m
        GROUP BY m.ITEM_CATEGORY
        ORDER BY COUNT(*) DESC
        LIMIT 1
    """)
    category_stats = cursor.fetchone()
    total_categories = category_stats['total_categories']
    most_common_category = category_stats['most_common']
    least_common_category = category_stats['least_common']

    # Geographic Distribution
    cursor.execute("""
        SELECT 
            c.NAME as city_name,
            COUNT(m.MONUMENT_ID) as monument_count,
            COUNT(DISTINCT m.EXCAVATION_ID) as project_count
        FROM CITY c
        LEFT JOIN MONUMENT m ON c.CITY_ID = m.CITY_ID
        GROUP BY c.CITY_ID, c.NAME
        ORDER BY monument_count DESC
    """)
    city_distribution = cursor.fetchall()

    # Calculate geographic summary statistics
    cursor.execute("""
        SELECT 
            COUNT(DISTINCT cc.CITY_ID) as total_cities,
            AVG(cc.monument_count) as avg_monuments_per_city,
            (SELECT c.NAME 
             FROM CITY c
             LEFT JOIN MONUMENT m ON c.CITY_ID = m.CITY_ID
             GROUP BY c.CITY_ID, c.NAME
             ORDER BY COUNT(m.MONUMENT_ID) DESC
             LIMIT 1) as city_with_most_monuments
        FROM (
            SELECT c.CITY_ID, COUNT(m.MONUMENT_ID) as monument_count
            FROM CITY c
            LEFT JOIN MONUMENT m ON c.CITY_ID = m.CITY_ID
            GROUP BY c.CITY_ID
        ) AS cc
    """)
    geo_stats = cursor.fetchone()
    total_cities = geo_stats['total_cities']
    avg_monuments_per_city = geo_stats['avg_monuments_per_city'] or 0
    city_with_most_monuments = geo_stats['city_with_most_monuments']

    # Researcher Activity
    cursor.execute("""
        SELECT 
            p.NAME as project_name,
            COUNT(DISTINCT r.RESEARCHER_ID) as researcher_count,
            CASE 
                WHEN COUNT(DISTINCT r.RESEARCHER_ID) = 0 THEN 0
                ELSE ROUND(COUNT(m.MONUMENT_ID) * 1.0 / COUNT(DISTINCT r.RESEARCHER_ID), 1)
            END as monuments_per_researcher
        FROM EXCAVATION_PROJECT p
        LEFT JOIN RESEARCHER r ON p.EXCAVATION_ID = r.EXCAVATION_ID
        LEFT JOIN MONUMENT m ON p.EXCAVATION_ID = m.EXCAVATION_ID
        GROUP BY p.EXCAVATION_ID, p.NAME
        ORDER BY researcher_count DESC
    """)
    researcher_activity = cursor.fetchall()

    # Calculate researcher summary statistics
    cursor.execute("""
        SELECT 
            (SELECT COUNT(DISTINCT r.RESEARCHER_ID) FROM RESEARCHER r) as total_researchers,
            AVG(rc.researcher_count) as avg_researchers_per_project,
            (SELECT p.NAME 
             FROM EXCAVATION_PROJECT p
             LEFT JOIN RESEARCHER r ON p.EXCAVATION_ID = r.EXCAVATION_ID
             GROUP BY p.EXCAVATION_ID, p.NAME
             ORDER BY COUNT(DISTINCT r.RESEARCHER_ID) DESC
             LIMIT 1) as project_with_most_researchers
        FROM (
            SELECT p.EXCAVATION_ID, COUNT(DISTINCT r.RESEARCHER_ID) as researcher_count
            FROM EXCAVATION_PROJECT p
            LEFT JOIN RESEARCHER r ON p.EXCAVATION_ID = r.EXCAVATION_ID
            GROUP BY p.EXCAVATION_ID
        ) AS rc
    """)
    researcher_stats = cursor.fetchone()
    total_researchers = researcher_stats['total_researchers']
    avg_researchers_per_project = researcher_stats['avg_researchers_per_project'] or 0
    project_with_most_researchers = researcher_stats['project_with_most_researchers']

    # Monument Documentation
    cursor.execute("""
        SELECT 
            CASE 
                WHEN m.CONDITION_NOTES IS NULL OR m.CONDITION_NOTES = '' THEN 'Not Documented'
                ELSE 'Documented'
            END as status,
            COUNT(*) as count,
            ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM MONUMENT), 1) as percentage
        FROM MONUMENT m
        GROUP BY status
    """)
    documentation_status = cursor.fetchall()

    # Calculate documentation summary statistics
    cursor.execute("""
        SELECT 
            COUNT(*) as total_documented,
            ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM MONUMENT), 1) as documentation_rate,
            AVG(LENGTH(m.CONDITION_NOTES)) as avg_notes_length
        FROM MONUMENT m
        WHERE m.CONDITION_NOTES IS NOT NULL AND m.CONDITION_NOTES != ''
    """)
    doc_stats = cursor.fetchone()
    total_documented = doc_stats['total_documented']
    documentation_rate = doc_stats['documentation_rate'] or 0
    avg_notes_length = doc_stats['avg_notes_length'] or 0

    cursor.close()
    conn.close()

    return render_template('researcher_statistics.html',
                         project_distribution=project_distribution,
                         total_projects=total_projects,
                         avg_monuments_per_project=avg_monuments_per_project,
                         max_monuments_in_project=max_monuments_in_project,
                         category_distribution=category_distribution,
                         total_categories=total_categories,
                         most_common_category=most_common_category,
                         least_common_category=least_common_category,
                         city_distribution=city_distribution,
                         total_cities=total_cities,
                         avg_monuments_per_city=avg_monuments_per_city,
                         city_with_most_monuments=city_with_most_monuments,
                         researcher_activity=researcher_activity,
                         total_researchers=total_researchers,
                         avg_researchers_per_project=avg_researchers_per_project,
                         project_with_most_researchers=project_with_most_researchers,
                         documentation_status=documentation_status,
                         total_documented=total_documented,
                         documentation_rate=documentation_rate,
                         avg_notes_length=avg_notes_length)

if __name__ == '__main__':
    #print(app.url_map)
    app.run(debug=True)