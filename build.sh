#!/usr/bin/env bash
set -e

echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

echo "Checking DATABASE_URL..."
if [ -z "$DATABASE_URL" ]; then
    echo "⚠️  WARNING: DATABASE_URL not set! Using SQLite."
else
    echo "✓ DATABASE_URL is configured"
fi

echo "Running Django migrations..."
python manage.py migrate --noinput

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "✓ Build complete!"


