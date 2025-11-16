.PHONY: help build up down restart logs clean migrate superuser test init-db rebuild

help:
	@echo "Starsmap Project - Available commands:"
	@echo ""
	@echo "  make install      - Complete installation (build + start + init)"
	@echo "  make rebuild      - Full rebuild (clean + build + start + init)"
	@echo "  make build        - Build all Docker images"
	@echo "  make up           - Start all services"
	@echo "  make down         - Stop all services"
	@echo "  make restart      - Restart all services"
	@echo "  make logs         - Show logs from all services"
	@echo "  make clean        - Remove all containers, volumes and images"
	@echo "  make migrate      - Run database migrations"
	@echo "  make init-db      - Initialize database with mock data"
	@echo "  make superuser    - Create Django superuser"
	@echo "  make test         - Run backend tests"
	@echo "  make dev          - Start in development mode"
	@echo ""

build:
	@echo "Building Docker images..."
	docker-compose build

up:
	@echo "Starting all services..."
	docker-compose up -d
	@echo ""
	@echo "✓ Application is starting..."
	@echo "  Frontend: http://localhost"
	@echo "  Backend API: http://localhost/api/"
	@echo "  Admin Panel: http://localhost/admin/"
	@echo ""
	@echo "Waiting for services to be ready..."
	@sleep 10
	@echo "✓ Application is ready!"

down:
	@echo "Stopping all services..."
	docker-compose down

restart: down up

logs:
	docker-compose logs -f

logs-backend:
	docker-compose logs -f backend

logs-frontend:
	docker-compose logs -f frontend

logs-nginx:
	docker-compose logs -f nginx

clean:
	@echo "Cleaning up Docker resources..."
	docker-compose down -v
	docker system prune -f

migrate:
	@echo "Running database migrations..."
	docker-compose exec backend python manage.py migrate

init-db:
	@echo "Initializing database with mock data..."
	docker-compose exec backend python init_db.py

superuser:
	@echo "Creating Django superuser..."
	docker-compose exec backend python manage.py createsuperuser

test:
	@echo "Running tests..."
	docker-compose exec backend python manage.py test

shell:
	docker-compose exec backend python manage.py shell

dev:
	@echo "Starting in development mode..."
	docker-compose up

status:
	docker-compose ps

install: build up
	@echo ""
	@echo "Waiting for services to initialize..."
	@sleep 25
	@echo ""
	@echo "Initializing database with mock data..."
	@docker-compose exec backend python init_db.py
	@echo ""
	@echo "=========================================="
	@echo "✓ Installation complete!"
	@echo "=========================================="
	@echo ""
	@echo "Application URLs:"
	@echo "  Frontend: http://localhost"
	@echo "  API: http://localhost/api/"
	@echo "  Admin: http://localhost/admin/"
	@echo "  API Docs: http://localhost/api/schema/swagger-ui/"
	@echo ""
	@echo "Admin credentials:"
	@echo "  Username: admin"
	@echo "  Password: admin123"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Open http://localhost"
	@echo "  2. Login to admin with credentials above"
	@echo "  3. View logs: make logs"
	@echo ""

rebuild: clean build up
	@echo ""
	@echo "Waiting for services to initialize..."
	@sleep 25
	@echo ""
	@echo "Initializing database with mock data..."
	@docker-compose exec backend python init_db.py
	@echo ""
	@echo "=========================================="
	@echo "✓ Rebuild complete!"
	@echo "=========================================="
	@echo ""
	@echo "Application URLs:"
	@echo "  Frontend: http://localhost"
	@echo "  API: http://localhost/api/"
	@echo "  Admin: http://localhost/admin/"
	@echo "  API Docs: http://localhost/api/schema/swagger-ui/"
	@echo ""
	@echo "Admin credentials:"
	@echo "  Username: admin"
	@echo "  Password: admin123"
	@echo ""
