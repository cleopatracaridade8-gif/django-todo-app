# Pre-Deployment Checklist

Use this checklist before deploying to any platform.

## Code Quality

- [ ] ✅ `todos/models.py` - Meta class properly indented (fixed)
- [ ] ✅ `requirements.txt` - Using compatible package versions (fixed)
- [ ] ✅ `manage.py` exists in project root
- [ ] ✅ All migrations exist in `todos/migrations/`
- [ ] ✅ `todoproject/settings.py` has DATABASE configuration
- [ ] ✅ `todoproject/urls.py` includes `todos.urls`
- [ ] ✅ `todoproject/wsgi.py` exists
- [ ] ✅ `.gitignore` excludes `db.sqlite3`, `__pycache__`, `.env`, `venv/`

## Configuration Files

- [ ] ✅ `Procfile` - Contains: `web: python manage.py migrate --noinput && gunicorn todoproject.wsgi:application`
- [ ] ✅ `render.yaml` - Properly configured with buildCommand and startCommand
- [ ] ✅ `runtime.txt` - Python version pinned (optional but recommended)
- [ ] ✅ `.env.example` - Shows required environment variables (for reference)

## Environment Variables (must be set on your platform)

- [ ] `DEBUG=False` (production)
- [ ] `SECRET_KEY=<generate-new-key>` (use: `python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'`)
- [ ] `ALLOWED_HOSTS=<your-domain>,*.render.com,localhost` (for Render)
- [ ] `CSRF_TRUSTED_ORIGINS=https://<your-domain>` (must be HTTPS)
- [ ] `DATABASE_URL=<postgres-connection-string>` (for Render/Railway)

## Database Setup

### For Render:
- [ ] PostgreSQL database created on Render
- [ ] `DATABASE_URL` auto-populated
- [ ] Start command includes: `python manage.py migrate --noinput`

### For Railway:
- [ ] PostgreSQL database created on Railway
- [ ] `DATABASE_URL` set automatically
- [ ] `Procfile` includes migration command

### For PythonAnywhere:
- [ ] Virtual environment created: `mkvirtualenv --python=/usr/bin/python3.10 django-todo`
- [ ] Requirements installed: `pip install -r requirements.txt`
- [ ] Migrations run: `python manage.py migrate`
- [ ] Static files collected: `python manage.py collectstatic --noinput`
- [ ] WSGI file configured with correct paths
- [ ] Virtualenv path set in Web app settings

## Pre-Flight Testing (Local)

Run these commands locally before pushing:

```bash
# Install dependencies
pip install -r requirements.txt

# Run migrations
python manage.py migrate

# Collect static files
python manage.py collectstatic --noinput

# Test the app locally
python manage.py runserver
```

- [ ] App runs without errors at http://127.0.0.1:8000
- [ ] Homepage loads (todo list visible)
- [ ] Can create a todo
- [ ] Can mark todo as complete
- [ ] Can delete a todo

## Git Commits

Before pushing to GitHub:

```bash
git add .
git commit -m "Production-ready: fix migrations, update requirements, configure deployment"
git push origin main
```

- [ ] All changes committed
- [ ] Code pushed to GitHub main branch
- [ ] No uncommitted changes

## Deployment Steps

### On Your Platform (Render/Railway/PythonAnywhere):

1. [ ] Create PostgreSQL database (if needed)
2. [ ] Create web service
3. [ ] Set all environment variables
4. [ ] Set correct build and start commands
5. [ ] Deploy/Redeploy
6. [ ] Check logs for errors

## Post-Deployment Verification

- [ ] Visit your live URL: `https://your-domain.com`
- [ ] Homepage loads without 500 error
- [ ] No database table errors
- [ ] Can create a todo
- [ ] Can view todos
- [ ] Can mark as complete
- [ ] Can delete todos
- [ ] Admin page accessible: `/admin`
- [ ] Check platform logs for warnings

## Common Issues & Solutions

If you see **500 errors**:
- [ ] Check platform logs
- [ ] Ensure all environment variables are set
- [ ] Verify migrations ran: check logs for "Running migrations"
- [ ] Check `ALLOWED_HOSTS` matches your domain

If you see **"no such table: todos_todo"**:
- [ ] Migrations didn't run
- [ ] Ensure build command includes: `python manage.py migrate --noinput`
- [ ] Manually run in platform console if available

If you see **DisallowedHost error**:
- [ ] Update `ALLOWED_HOSTS` to include your domain
- [ ] Format: `your-domain.com,*.render.com,localhost`

If **CSS/JS not loading**:
- [ ] Run: `python manage.py collectstatic --noinput`
- [ ] Check `STATIC_ROOT` path in settings.py

---

## Ready to Deploy? ✅

If you've checked all items above, you're ready to deploy!

**Next Steps:**
1. Commit all changes: `git push origin main`
2. Follow the platform-specific guide in `DEPLOYMENT_GUIDE.md`
3. Monitor logs during deployment
4. Test the live application
