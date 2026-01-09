#!/bin/bash

# Startup script for Awsome Recipe Cookbook
# Switches between development and production mode

# Initialize database
python -c "from app import init_db; init_db()"

# Check if we're in production mode
if [ "$FLASK_ENV" = "production" ]; then
    echo "Starting in PRODUCTION mode with Gunicorn on port 80..."
    exec gunicorn --bind 0.0.0.0:80 --workers 4 --timeout 120 app:app
else
    echo "Starting in DEVELOPMENT mode with Flask dev server on port 5001..."
    exec python app.py
fi
