#!/usr/bin/env python
"""
Скрипт для создания миграций Django
"""
import os
import sys
import django
from django.core.management import call_command

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'starsmap.settings')
django.setup()

print("Creating migrations...")
try:
    call_command('makemigrations', 'specialties', verbosity=2)
    call_command('makemigrations', 'teams', verbosity=2)
    print("✓ Migrations created successfully!")
except Exception as e:
    print(f"Error creating migrations: {e}")
    sys.exit(1)
