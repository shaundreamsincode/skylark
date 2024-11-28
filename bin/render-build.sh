#!/usr/bin/env bash


#!/usr/bin/env bash
# Exit on error
set -o errexit

# Install dependencies
bundle install

# Compile Webpacker assets
bundle exec rails webpacker:compile

# Precompile Rails assets (CSS, images, etc.)
bundle exec rails assets:precompile

# Clean up old assets
bundle exec rails assets:clean

# Migrate the database
bundle exec rails db:migrate


## exit on error
#set -o errexit
#
#bundle install
#bundle exec rails assets:precompile
#bundle exec rails assets:clean
#bundle exec rails db:migrate
