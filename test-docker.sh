#!/bin/bash

# Test script for Skylark Docker setup
set -e

echo "🐳 Testing Skylark Docker Setup"
echo "================================"

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop first."
    exit 1
fi

echo "✅ Docker is running"

# Check if we're in the right directory
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ Please run this script from the Skylark project root directory"
    exit 1
fi

echo "✅ In correct directory"

# Function to cleanup
cleanup() {
    echo "🧹 Cleaning up..."
    docker compose -f docker-compose.dev.yml down -v
    docker system prune -f
}

# Set trap to cleanup on exit
trap cleanup EXIT

echo "🔨 Building and starting services..."
docker compose -f docker-compose.dev.yml up --build -d

echo "⏳ Waiting for services to be ready..."
sleep 30

# Check if services are running
echo "🔍 Checking service status..."
docker compose -f docker-compose.dev.yml ps

# Test database connection
echo "🗄️  Testing database connection..."
docker compose -f docker-compose.dev.yml exec -T web rails db:migrate:status

# Test web service
echo "🌐 Testing web service..."
if curl -f http://localhost:3000 > /dev/null 2>&1; then
    echo "✅ Web service is responding"
else
    echo "❌ Web service is not responding"
    echo "📋 Checking logs..."
    docker compose -f docker-compose.dev.yml logs web
    exit 1
fi

echo ""
echo "🎉 All tests passed! Your application is running at:"
echo "   http://localhost:3000"
echo "   Live demo: https://skylark-3kbo.onrender.com/"
echo ""
echo "📋 Useful commands:"
echo "   View logs: docker compose -f docker-compose.dev.yml logs -f"
echo "   Stop services: docker compose -f docker-compose.dev.yml down"
echo "   Rails console: docker compose -f docker-compose.dev.yml exec web rails console"
echo "   Run tests: docker compose -f docker-compose.dev.yml exec web rails test" 