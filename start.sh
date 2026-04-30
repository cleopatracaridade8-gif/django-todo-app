#!/usr/bin/env bash
cd django_todo
gunicorn todoproject.wsgi:application
