# Skylark

Skylark is a collaborative project management and community platform built with Ruby on Rails and React. It provides a space for organizations and individuals to manage projects, share information, and collaborate effectively.

## Features

- **Project Management**
  - Create and manage projects
  - Add project members and assign roles
  - Track project progress with notes and notifications
  - Tag projects for better organization

- **Organization Management**
  - Create and manage organizations
  - Add organization members
  - Control access and permissions

- **Information Requests**
  - Create and respond to information requests
  - Public request system for community engagement
  - Track request status and responses

- **User Management**
  - User authentication and authorization
  - User profiles and settings
  - Notification system

- **Search and Discovery**
  - Search functionality across projects and content
  - Category and tag-based organization
  - Explore section for discovering content

## Tech Stack

- **Backend**
  - Ruby on Rails 6.1.7
  - PostgreSQL database
  - Puma web server
  - Redis (optional, for Action Cable)

- **Frontend**
  - React/JavaScript
  - Webpacker
  - TailwindCSS for styling
  - Turbolinks for faster navigation

- **Development Tools**
  - Pry for debugging
  - RSpec for testing
  - Capybara for system testing
  - Webpack for asset compilation

- **Deployment**
  - Docker and Docker Compose
  - Multi-stage builds for optimization
  - Health checks and proper service orchestration

## Prerequisites

- Ruby 3.2.2
- PostgreSQL
- Node.js and Yarn
- Redis (optional)
- Docker and Docker Compose (for containerized deployment)

## Installation

### Option 1: Docker (Recommended)

1. Clone the repository:
   ```bash
   git clone [repository-url]
   cd skylark
   ```

2. Set up your Rails master key (for production):
   ```bash
   # Copy your master key to an environment variable
   export RAILS_MASTER_KEY=your_master_key_here
   ```

3. Start the application with Docker Compose:
   ```bash
   # For development
   docker-compose -f docker-compose.dev.yml up --build
   
   # For production
   docker-compose up --build
   ```

4. The application will be available at `http://localhost:3000`

### Option 2: Local Development

1. Clone the repository:
   ```bash
   git clone [repository-url]
   cd skylark
   ```

2. Install Ruby dependencies:
   ```bash
   bundle install
   ```

3. Install JavaScript dependencies:
   ```bash
   yarn install
   ```

4. Set up the database:
   ```bash
   rails db:create
   rails db:migrate
   ```

5. Start the development server:
   ```bash
   ./bin/dev
   ```

## Development

- Run tests:
  ```bash
  rails test
  ```

- Start the Rails console:
  ```bash
  rails console
  ```

- Start the development server:
  ```bash
  ./bin/dev
  ```

## Docker Commands

- Build and start all services:
  ```bash
  docker-compose up --build
  ```

- Start services in background:
  ```bash
  docker-compose up -d
  ```

- View logs:
  ```bash
  docker-compose logs -f web
  ```

- Run Rails commands in container:
  ```bash
  docker-compose exec web rails console
  docker-compose exec web rails db:migrate
  ```

- Stop all services:
  ```bash
  docker-compose down
  ```

- Clean up volumes:
  ```bash
  docker-compose down -v
  ```

## Deployment

### Render.com (Recommended)

This application is configured for easy deployment on Render.com using Docker.

#### Quick Deploy

1. **Fork or push** this repository to GitHub
2. **Connect to Render** and create a new Blueprint
3. **Set environment variables** (especially `RAILS_MASTER_KEY`)
4. **Deploy** - Render will handle the rest!

#### Manual Setup

See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed deployment instructions.

#### Benefits of Docker on Render

- **Consistent Environment**: Same container in dev and production
- **Better Performance**: Optimized multi-stage builds
- **Easier Scaling**: Horizontal scaling with load balancing
- **Health Monitoring**: Built-in health checks
- **Resource Efficiency**: Smaller image sizes with Alpine Linux

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

[Add license information here]

## Support

[Add support information here]