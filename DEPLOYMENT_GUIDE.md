# Comprehensive Django Deployment Guide

This guide covers deployment on Render, Railway, PythonAnywhere, and other platforms.

## Prerequisites

- Your code pushed to GitHub
- `requirements.txt` properly configured
- Django migrations created and committed
- `SECRET_KEY` environment variable set
- Database connection string (if using PostgreSQL)

## Common Fixes Applied

✅ **Fixed Model indentation** - Meta class now properly outside __str__ method
✅ **Updated requirements.txt** - Using psycopg[binary] for better compatibility
✅ **Ensured migrations run** - Both build and startup commands include migrations
✅ **Set DEBUG=False** - Production-safe configuration
✅ **Configured ALLOWED_HOSTS** - Properly handles multiple domains
✅ **Static files collection** - WhiteNoise properly configured

---

## Deployment on Render

### Step 1: Create PostgreSQL Database
1. Go to Render Dashboard
2. Click "New +" → "PostgreSQL"
3. Name it `todo_db`, select Free tier
4. Copy the connection string (auto-populates as DATABASE_URL)

### Step 2: Create Web Service
1. Click "New +" → "Web Service"
2. Connect your GitHub repository
3. Configure:
   - **Name**: django-todo
   - **Environment**: Python
   - **Region**: Choose nearest
   - **Build Command**: `pip install -r requirements.txt && python manage.py migrate --noinput && python manage.py collectstatic --noinput`
   - **Start Command**: `python manage.py migrate --noinput && gunicorn todoproject.wsgi:application`

### Step 3: Set Environment Variables
In the **Environment** tab, add:
- `DEBUG`: `False`
- `SECRET_KEY`: Generate one: `python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'`
- `ALLOWED_HOSTS`: `your-service.onrender.com,*.render.com`
- `CSRF_TRUSTED_ORIGINS`: `https://your-service.onrender.com`
- `PYTHON_VERSION`: `3.11` (optional)

### Step 4: Deploy
Click **Manual Deploy** → **Deploy**

---

## Deployment on Railway

### Step 1: Create PostgreSQL Database
1. Go to Railway Dashboard
2. Click "New" → "Database" → "PostgreSQL"
3. It auto-populates `DATABASE_URL`

### Step 2: Create Web Service
1. Click "New" → "GitHub Repo"
2. Select your repository
3. Railway auto-detects it's a Python/Django app

### Step 3: Set Environment Variables
Add these in the **Variables** tab:
- `DEBUG`: `False`
- `SECRET_KEY`: Your random secret key
- `ALLOWED_HOSTS`: `your-railway-domain,*.railway.app,localhost`

### Step 4: Configure Start Command
In your repo root, create a `Procfile` with:
```
web: python manage.py migrate --noinput && gunicorn todoproject.wsgi:application
```

### Step 5: Deploy
Push to GitHub and Railway auto-deploys

---

## Deployment on PythonAnywhere

### Step 1: Clone Your Repository
In PythonAnywhere Bash Console:
```bash
cd ~
git clone https://github.com/YOUR_USERNAME/django-todo-app.git
cd django-todo-app
```

### Step 2: Create Virtual Environment
```bash
mkvirtualenv --python=/usr/bin/python3.10 django-todo
pip install -r requirements.txt
```

### Step 3: Run Migrations
```bash
python manage.py migrate
python manage.py collectstatic --noinput
```

### Step 4: Configure Web App
1. Go to **Web** tab
2. Click "Add a new web app" → "Manual configuration" → Python 3.10
3. Set **Virtualenv** to: `/home/USERNAME/.virtualenvs/django-todo`
4. Set **Source code** to: `/home/USERNAME/django-todo-app`

### Step 5: Edit WSGI File
Click to edit your WSGI file (`/var/www/USERNAME_pythonanywhere_com_wsgi.py`):

```python
import os
import sys

project_home = u'/home/USERNAME/django-todo-app'
if project_home not in sys.path:
    sys.path.insert(0, project_home)

os.environ['DJANGO_SETTINGS_MODULE'] = 'todoproject.settings'
os.environ.setdefault('DEBUG', 'False')
os.environ.setdefault('SECRET_KEY', 'your-secret-key-here')
os.environ.setdefault('ALLOWED_HOSTS', 'USERNAME.pythonanywhere.com,localhost')

from django.core.wsgi import get_wsgi_application
application = get_wsgi_application()
```

Replace `USERNAME` with your PythonAnywhere username.

### Step 6: Reload
Click the **green Reload button**

---

## Testing Locally Before Deployment

### Step 1: Create .env file (local testing only)
```bash
DEBUG=True
SECRET_KEY=django-insecure-test-key-here
ALLOWED_HOSTS=localhost,127.0.0.1
```

### Step 2: Run migrations
```bash
python manage.py migrate
```

### Step 3: Create superuser (optional)
```bash
python manage.py createsuperuser
```

### Step 4: Test locally
```bash
python manage.py runserver
```

Visit http://127.0.0.1:8000/

---

## Troubleshooting

### Error: `no such table: todos_todo`
**Solution:** Migrations didn't run. Ensure your start/build command includes:
```bash
python manage.py migrate --noinput
```

### Error: `ModuleNotFoundError: No module named 'decouple'`
**Solution:** Install requirements in virtualenv:
```bash
pip install -r requirements.txt
```

### Error: `DisallowedHost` / 500 error
**Solution:** Update `ALLOWED_HOSTS` environment variable:
```
ALLOWED_HOSTS=your-domain.com,*.render.com,localhost
```

### Error: Static files not loading (CSS/JS broken)
**Solution:** Run collectstatic:
```bash
python manage.py collectstatic --noinput
```

### Error: `SECRET_KEY` not found
**Solution:** Generate and set it:
```bash
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

---

## Environment Variables Checklist

✅ **DEBUG** = `False` (production)  
✅ **SECRET_KEY** = Random Django secret key (unique per environment)  
✅ **ALLOWED_HOSTS** = Your domain + localhost  
✅ **CSRF_TRUSTED_ORIGINS** = HTTPS URL of your domain  
✅ **DATABASE_URL** = PostgreSQL connection string (auto-set on Render/Railway)  

---

## Post-Deployment Steps

1. Visit your deployed URL
2. Test creating a todo item
3. Test marking as complete
4. Test deleting a todo
5. Check Django admin: `/admin`

---

## Need Help?

Check your platform's error logs:
- **Render**: Dashboard → Logs
- **Railway**: Dashboard → Logs
- **PythonAnywhere**: Web app → Error/Access logs
