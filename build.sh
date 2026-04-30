#!/usr/bin/env bash
set -e

cd django_todo

echo "Installing dependencies..."
pip install --upgrade pip
pip install -r requirements.txt

echo "Running Django migrations..."
python manage.py migrate --noinput

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "✓ Build complete!"
