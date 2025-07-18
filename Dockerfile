# Use the official Ruby image as base
FROM ruby:3.2.2-alpine

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    postgresql-dev \
    postgresql-client \
    nodejs \
    yarn \
    tzdata \
    git \
    bash \
    libc6-compat

# Set working directory
WORKDIR /app

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install Ruby gems
RUN bundle install --jobs 4 --retry 3

# Copy package.json and yarn.lock
COPY package.json yarn.lock ./

# Install JavaScript dependencies
RUN yarn install --frozen-lockfile

# Copy the rest of the application
COPY . .

# Add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Configure the main process to run when running the image
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"] 