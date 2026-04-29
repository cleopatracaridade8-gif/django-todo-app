# Django Todo App - Render Deployment Guide

## Prerequisites
- GitHub account with your repository pushed
- Render account (https://render.com)

## Deployment Steps

### 1. Push Your Code to GitHub
```bash
git add .
git commit -m "Prepare for Render deployment"
git push origin main
```

### 2. Create a Render Account
- Go to https://render.com
- Sign up or log in with GitHub

### 3. Generate a Secret Key
Generate a secure Django secret key:
```bash
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

### 4. Deploy from GitHub
1. Click "New +" on your Render dashboard
2. Select "Web Service"
3. Connect your GitHub repository
4. Configure the service:
   - **Name**: django-todo (or your preferred name)
   - **Environment**: Python 3
   - **Build Command**: `pip install -r requirements.txt && python manage.py migrate && python manage.py collectstatic --no-input`
   - **Start Command**: `gunicorn todoproject.wsgi:application`

### 5. Set Environment Variables
In the Render dashboard, go to your web service **Environment** tab and add these environment variables:
- `DEBUG`: `False`
- `SECRET_KEY`: Paste your generated secret key from Step 3
- `ALLOWED_HOSTS`: Your Render domain (e.g., `yourdomain.onrender.com`)
- `CSRF_TRUSTED_ORIGINS`: `https://yourdomain.onrender.com`
- `PYTHON_VERSION`: `3.11.0` (optional, will use default if not set)

**Important**: Make sure `SECRET_KEY` is set before deploying, as it's required for Django to start.

### 6. Create PostgreSQL Database
1. In Render dashboard, click "New +" → "PostgreSQL"
2. Name it `todo_db`
3. Choose free tier
4. Copy the database URL and add it to your web service as `DATABASE_URL`

### 7. Deploy
- Render will automatically deploy when you push to GitHub
- Check the deployment logs in the Render dashboard

## Features Included

✅ **WhiteNoise**: Serves static files efficiently  
✅ **PostgreSQL**: Production-ready database  
✅ **Gunicorn**: Production WSGI server  
✅ **Environment Variables**: Secure configuration management  
✅ **Security Headers**: HTTPS, HSTS, CSRF protection  
✅ **Static Files**: Automatic collection and optimization  

## Local Development

To test locally before deploying:

1. Create a `.env` file (copy from `.env.example`)
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Run migrations:
   ```bash
   python manage.py migrate
   ```
4. Start the server:
   ```bash
   python manage.py runserver
   ```

## Troubleshooting

### Database Connection Error
- Make sure `DATABASE_URL` is set correctly in Render
- PostgreSQL service should be running

### Static Files Not Loading
- Run: `python manage.py collectstatic --no-input`
- Check that `STATIC_ROOT` and `STATIC_URL` are configured

### Import Errors
- Check that all packages in `requirements.txt` are installed
- Run: `pip install -r requirements.txt`

## Production Checklist
- [ ] SECRET_KEY is set to a random value
- [ ] DEBUG is set to False
- [ ] ALLOWED_HOSTS is configured correctly
- [ ] Database is connected and migrations run
- [ ] Static files are collected
- [ ] HTTPS is enabled (automatic on Render)

## Support
For more information, see:
- Render Documentation: https://render.com/docs
- Django Deployment: https://docs.djangoproject.com/en/6.0/howto/deployment/
