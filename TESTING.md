# Testing Guide for Skylark

This guide covers how to test your dockerized Skylark application.

🌐 **Live Demo**: [https://skylark-3kbo.onrender.com/](https://skylark-3kbo.onrender.com/)

## Prerequisites

1. **Docker Desktop** installed and running
2. **Git** for cloning the repository
3. **curl** for HTTP testing (usually pre-installed on macOS/Linux)

## Quick Start Testing

### 1. Automated Test Script

Run the automated test script:

```bash
./test-docker.sh
```

This script will:
- Check if Docker is running
- Build and start all services
- Wait for services to be ready
- Test database connectivity
- Test web service responsiveness
- Show useful commands

### 2. Manual Testing Steps

If you prefer to test manually:

#### Step 1: Start Docker Desktop
Make sure Docker Desktop is running on your machine.

#### Step 2: Build and Start Services
```bash
# For development
docker compose -f docker-compose.dev.yml up --build -d

# For production (requires RAILS_MASTER_KEY)
export RAILS_MASTER_KEY=your_master_key_here
docker compose up --build -d
```

#### Step 3: Check Service Status
```bash
docker compose -f docker-compose.dev.yml ps
```

You should see:
- `web` service running
- `db` service running  
- `redis` service running

#### Step 4: Test Database Connection
```bash
docker compose -f docker-compose.dev.yml exec web rails db:migrate:status
```

#### Step 5: Test Web Application
```bash
curl -I http://localhost:3000
```

Should return HTTP 200 OK.

## Comprehensive Testing

### 1. Service Health Checks

Check if all services are healthy:

```bash
# Check web service logs
docker compose -f docker-compose.dev.yml logs web

# Check database logs
docker compose -f docker-compose.dev.yml logs db

# Check Redis logs
docker compose -f docker-compose.dev.yml logs redis
```

### 2. Application Functionality Tests

#### Test User Registration
```bash
curl -X POST http://localhost:3000/users \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "user[first_name]=Test&user[last_name]=User&user[email]=test@example.com&user[password]=password123"
```

#### Test User Login
```bash
curl -X POST http://localhost:3000/sessions \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "email=test@example.com&password=password123"
```

### 3. Database Tests

#### Run Rails Tests
```bash
docker compose -f docker-compose.dev.yml exec web rails test
```

#### Run RSpec Tests (if available)
```bash
docker compose -f docker-compose.dev.yml exec web bundle exec rspec
```

#### Database Console
```bash
docker compose -f docker-compose.dev.yml exec web rails console
```

### 4. Performance Tests

#### Check Resource Usage
```bash
docker stats
```

#### Load Test (requires Apache Bench)
```bash
# Install ab if not available
# macOS: brew install httpd
# Ubuntu: sudo apt-get install apache2-utils

ab -n 100 -c 10 http://localhost:3000/
```

## Troubleshooting

### Common Issues

#### 1. Docker Not Running
```bash
# Start Docker Desktop manually
# Or check if Docker service is running
docker info
```

#### 2. Port Already in Use
```bash
# Check what's using port 3000
lsof -i :3000

# Kill the process or change port in docker-compose.yml
```

#### 3. Database Connection Issues
```bash
# Check if database is ready
docker compose -f docker-compose.dev.yml exec db pg_isready -U skylark

# Reset database
docker compose -f docker-compose.dev.yml exec web rails db:reset
```

#### 4. Asset Compilation Issues
```bash
# Recompile assets
docker compose -f docker-compose.dev.yml exec web rails assets:precompile

# Clear cache
docker compose -f docker-compose.dev.yml exec web rails tmp:clear
```

### Debug Commands

#### View Real-time Logs
```bash
docker compose -f docker-compose.dev.yml logs -f
```

#### Access Container Shell
```bash
docker compose -f docker-compose.dev.yml exec web bash
```

#### Check Environment Variables
```bash
docker compose -f docker-compose.dev.yml exec web env
```

## Production Testing

### 1. Production Build Test
```bash
# Set master key
export RAILS_MASTER_KEY=your_master_key_here

# Build and start production services
docker compose up --build -d

# Test production environment
curl -I http://localhost:3000
```

### 2. Security Testing
```bash
# Test HTTPS redirect (if configured)
curl -I http://localhost:3000 -H "X-Forwarded-Proto: https"

# Test CSRF protection
curl -X POST http://localhost:3000/users -H "Content-Type: application/json"
```

## Cleanup

### Stop Services
```bash
docker compose -f docker-compose.dev.yml down
```

### Remove Volumes (WARNING: This deletes all data)
```bash
docker compose -f docker-compose.dev.yml down -v
```

### Clean Docker System
```bash
docker system prune -f
```

## Continuous Integration

For CI/CD testing, you can use:

```bash
# Build without cache
docker compose -f docker-compose.dev.yml build --no-cache

# Run tests in CI environment
docker compose -f docker-compose.dev.yml run --rm web rails test

# Check for security vulnerabilities
docker scan skylark-web:latest
```

## Monitoring

### Health Check Endpoint
Add this to your Rails app for automated health checks:

```ruby
# In config/routes.rb
get '/health', to: proc { [200, {}, ['OK']] }
```

### Log Monitoring
```bash
# Monitor application logs
docker compose -f docker-compose.dev.yml logs -f web | grep ERROR

# Monitor database logs
docker compose -f docker-compose.dev.yml logs -f db | grep ERROR
``` 