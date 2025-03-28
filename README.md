# endangered-monuments
Dependencies are located in requirements.txt and can be installed with pip install -r requirements.txt

## Flask Application
1. User visits a URL in the application
2. Flask routes that request to the appropriate function
3. The function gets any necessary data (from forms, database, etc.)
4. The function calls render_template() with:
    -> The template filename
    -> Variables the template needs
5. Flask finds the template and replaces variables and processes logic
6. The resulting HTML is sent back to the user's browser


