@echo off
setlocal enabledelayedexpansion

echo ==========================================
echo Starsmap - Quick Setup Script
echo ==========================================
echo.

where docker >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: Docker is not installed
    echo Please install Docker: https://docs.docker.com/get-docker/
    exit /b 1
)

where docker-compose >nul 2>nul
if %errorlevel% neq 0 (
    docker compose version >nul 2>nul
    if !errorlevel! neq 0 (
        echo Error: Docker Compose is not installed
        echo Please install Docker Compose: https://docs.docker.com/compose/install/
        exit /b 1
    )
)

echo [32m✓ Docker is installed[0m
echo [32m✓ Docker Compose is installed[0m
echo.

if not exist .env (
    echo Creating .env file from .env.example...
    copy .env.example .env >nul
    echo [32m✓ .env file created[0m
) else (
    echo [32m✓ .env file already exists[0m
)

if not exist backend\.env (
    echo Creating backend\.env file...
    copy backend\.env.example backend\.env >nul
    echo [32m✓ backend\.env file created[0m
) else (
    echo [32m✓ backend\.env file already exists[0m
)

if not exist frontend\.env (
    echo Creating frontend\.env file...
    copy frontend\.env.example frontend\.env >nul
    echo [32m✓ frontend\.env file created[0m
) else (
    echo [32m✓ frontend\.env file already exists[0m
)

echo.
echo Building Docker images...
docker-compose build

echo.
echo Starting services...
docker-compose up -d

echo.
echo Waiting for database to be ready...
timeout /t 10 /nobreak >nul

echo.
echo Running database migrations...
docker-compose exec -T backend python manage.py migrate

echo.
echo Collecting static files...
docker-compose exec -T backend python manage.py collectstatic --noinput

echo.
echo Initializing database with mock data...
docker-compose exec -T backend python init_db.py

echo.
echo ==========================================
echo [32m✓ Installation Complete![0m
echo ==========================================
echo.
echo Application URLs:
echo   Frontend:    http://localhost
echo   Backend API: http://localhost/api/
echo   Admin Panel: http://localhost/admin/
echo   API Docs:    http://localhost/api/schema/swagger-ui/
echo.
echo Admin credentials:
echo   Username: admin
echo   Password: admin123
echo.
echo Next steps:
echo   1. Open http://localhost
echo   2. Login to admin: http://localhost/admin/
echo   3. View logs: docker-compose logs -f
echo   4. Stop: docker-compose down
echo.

pause
