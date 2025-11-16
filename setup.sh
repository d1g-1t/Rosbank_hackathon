#!/bin/bash

set -e

echo "=========================================="
echo "Starsmap - Quick Setup Script"
echo "=========================================="
echo ""

if ! command -v docker &> /dev/null; then
    echo "❌ Error: Docker is not installed"
    echo "Please install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "❌ Error: Docker Compose is not installed"
    echo "Please install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✓ Docker is installed"
echo "✓ Docker Compose is installed"
echo ""

if [ ! -f .env ]; then
    echo "Creating .env file from .env.example..."
    cp .env.example .env
    echo "✓ .env file created"
else
    echo "✓ .env file already exists"
fi

if [ ! -f backend/.env ]; then
    echo "Creating backend/.env file..."
    cp backend/.env.example backend/.env
    echo "✓ backend/.env file created"
else
    echo "✓ backend/.env file already exists"
fi

if [ ! -f frontend/.env ]; then
    echo "Creating frontend/.env file..."
    cp frontend/.env.example frontend/.env
    echo "✓ frontend/.env file created"
else
    echo "✓ frontend/.env file already exists"
fi

echo ""
echo "Building Docker images..."
docker-compose build

echo ""
echo "Starting services..."
docker-compose up -d

echo ""
echo "Waiting for database to be ready..."
sleep 10

echo ""
echo "Running database migrations..."
docker-compose exec -T backend python manage.py migrate

echo ""
echo "Collecting static files..."
docker-compose exec -T backend python manage.py collectstatic --noinput

echo ""
echo "Initializing database with mock data..."
docker-compose exec -T backend python init_db.py

echo ""
echo "=========================================="
echo "✓ Installation Complete!"
echo "=========================================="
echo ""
echo "Application URLs:"
echo "  Frontend:    http://localhost"
echo "  Backend API: http://localhost/api/"
echo "  Admin Panel: http://localhost/admin/"
echo "  API Docs:    http://localhost/api/schema/swagger-ui/"
echo ""
echo "Admin credentials:"
echo "  Username: admin"
echo "  Password: admin123"
echo ""
echo "Next steps:"
echo "  1. Open http://localhost"
echo "  2. Login to admin: http://localhost/admin/"
echo "  3. View logs: docker-compose logs -f"
echo "  4. Stop: docker-compose down"
echo ""
