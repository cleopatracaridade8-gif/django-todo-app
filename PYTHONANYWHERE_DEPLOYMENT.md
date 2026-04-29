# Django Todo App - PythonAnywhere Deployment Guide

## Prerequisites
- GitHub account with your repository pushed
- PythonAnywhere account (https://www.pythonanywhere.com)

## Deployment Steps

### 1. Clone Your Repository on PythonAnywhere

1. Go to PythonAnywhere **Web** tab → **Add a new web app**
2. Choose **Manual configuration** → **Python 3.11** (or available version)
3. In the **Bash console**, clone your repo:

```bash
cd ~
git clone https://github.com/YOUR_USERNAME/django-todo-app.git
cd django-todo-app
```

### 2. Create and Activate Virtual Environment

```bash
mkvirtualenv --python=/usr/bin/python3.11 django-todo
pip install -r requirements.txt
```

### 3. Run Migrations

```bash
python manage.py migrate
python manage.py collectstatic --noinput
```

### 4. Configure the WSGI File

In the PythonAnywhere Web tab:

1. Find your **WSGI configuration file** (should be at `/var/www/username_pythonanywhere_com_wsgi.py`)
2. Click to edit it
3. Replace the entire content with:

```python
# ============================================================
# This WSGI file is required by PythonAnywhere to run your web app.
# ============================================================

import os
import sys

# Add your project directory to the Python path
project_home = u'/home/USERNAME/django-todo-app'
if project_home not in sys.path:
    sys.path.insert(0, project_home)

# Set up Django settings module
os.environ['DJANGO_SETTINGS_MODULE'] = 'todoproject.settings'

# Set debug to False in production
os.environ.setdefault('DEBUG', 'False')

# Get WSGI application
from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
```

**Important:** Replace `USERNAME` with your actual PythonAnywhere username!

### 5. Configure Environment Variables

In the Web tab, scroll to **Virtualenv section** and ensure it's set to:

```
/home/USERNAME/.virtualenvs/django-todo
```

### 6. Set Web App Domain

1. Go to **Web** tab
2. Your site URL will be: `https://USERNAME.pythonanywhere.com`
3. Update `ALLOWED_HOSTS` in settings if needed:

```python
ALLOWED_HOSTS = ['USERNAME.pythonanywhere.com']
```

### 7. Reload Your Web App

In the PythonAnywhere **Web** tab, click the **green Reload button** at the top.

### 8. Test Your App

Visit `https://USERNAME.pythonanywhere.com` in your browser. Your Django app should now be live!

## Troubleshooting

### Error: `ModuleNotFoundError: No module named 'todoproject'`
- Make sure the project path in the WSGI file is correct
- Check that you're using the correct virtualenv

### Error: `ModuleNotFoundError: No module named 'decouple'`
- Run: `pip install -r requirements.txt` in the virtualenv
- Make sure the virtualenv is activated

### Error: `no such table: todos_todo`
- Run: `python manage.py migrate` in the bash console

### Database Issues
PythonAnywhere uses SQLite by default. Your app should work with:
```
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
    }
}
```

## Need Help?

Refer to PythonAnywhere's official guide:
https://help.pythonanywhere.com/pages/Django/
