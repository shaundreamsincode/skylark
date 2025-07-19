#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Wait for database to be ready
echo "Waiting for database..."
while ! nc -z db 5432; do
  sleep 1
done
echo "Database is ready!"

# Run database migrations
echo "Running database migrations..."
bundle exec rails db:migrate

# Run database seeds based on environment and configuration
if [ "$RAILS_ENV" = "development" ] || [ "$SEED_DATABASE" = "true" ]; then
  echo "Seeding database..."
  bundle exec rails db:seed
elif [ "$SEED_DATABASE" = "force" ]; then
  echo "Force seeding database..."
  bundle exec rails db:seed
elif [ "$SEED_DATABASE" = "if_empty" ]; then
  # Only seed if database is empty (no users exist)
  if ! bundle exec rails runner "exit User.count > 0" 2>/dev/null; then
    echo "Database appears empty, seeding..."
    bundle exec rails db:seed
  else
    echo "Database not empty, skipping seed..."
  fi
fi

# Build CSS in development
if [ "$RAILS_ENV" = "development" ]; then
  echo "Building CSS..."
  ./bin/build-css
fi

# Precompile assets in production
if [ "$RAILS_ENV" = "production" ]; then
  echo "Precompiling assets..."
  bundle exec rails assets:precompile
fi

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@" 