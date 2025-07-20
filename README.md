# Skylark

Skylark is a collaborative project management and community platform built with Ruby on Rails. It provides a space for organizations and individuals to manage projects, share information, and collaborate effectively.

🌐 **Live Demo**: [https://skylark-3kbo.onrender.com/](https://skylark-3kbo.onrender.com/)
📹 **Loom Demo**: [https://www.loom.com/share/ad2f1257fbe3413197bc5a866610b5c9]
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
  - TailwindCSS for styling
  - Turbolinks for faster navigation

- **Development Tools**
  - Pry for debugging
  - RSpec for testing
  - Capybara for system testing

- **Deployment**
  - Docker and Docker Compose
  - Multi-stage builds for optimization
  - Health checks and proper service orchestration

## Prerequisites

- Ruby 3.2.2
- PostgreSQL
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
   docker compose -f docker-compose.dev.yml up --build
   
   # For production
   docker compose up --build
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

3. Set up the database:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed  # Optional: Populate with sample data
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
  docker compose up --build
  ```

- Start services in background:
  ```bash
  docker compose up -d
  ```

- View logs:
  ```bash
  docker compose logs -f web
  ```

- Run Rails commands in container:
  ```bash
  docker compose exec web rails console
  docker compose exec web rails db:migrate
  docker compose exec web rails db:seed  # Manually seed database
  ```

- Stop all services:
  ```bash
  docker compose down
  ```

- Clean up volumes:
  ```bash
  docker compose down -v
  ```

## Database Seeding

The application includes comprehensive seed data to help you get started quickly. The seeding behavior is controlled by environment variables:

### Automatic Seeding (Docker)

When using Docker, seeding happens automatically based on your configuration:

- **Development**: Seeds automatically on container start
- **Production**: Use environment variables to control seeding:
  ```bash
  # Always seed (good for staging/demo environments)
  SEED_DATABASE=true
  
  # Only seed if database is empty (smart for production)
  SEED_DATABASE=if_empty
  
  # Force seed (explicit override)
  SEED_DATABASE=force
  ```

### Manual Seeding

To manually seed the database:

```bash
# Local development
rails db:seed

# Docker container
docker compose exec web rails db:seed
```

### CSS Development

For CSS development in Docker:

```bash
# Build CSS manually when needed
docker compose -f docker-compose.dev.yml exec web ./bin/build-css

# Or rebuild CSS from outside the container
docker compose -f docker-compose.dev.yml exec web bundle exec rails tailwindcss:build
```

**Note**: CSS is automatically built when the container starts in development mode.

### Seed Data Includes

- **Users**: Admin user and sample users with realistic profiles
- **Organizations**: Sample organizations with descriptions
- **Tags & Categories**: Comprehensive tagging system
- **Projects**: Sample projects with realistic content
- **Memberships**: User-organization relationships

### Safe to Run Multiple Times

The seed file uses `find_or_create_by!` methods, which means:
- ✅ **No duplicate records**: Won't create duplicates if records already exist
- ✅ **No data loss**: Won't destroy or overwrite existing data
- ✅ **Safe for production**: Can be run safely in any environment
- ✅ **Idempotent**: Running multiple times has the same effect as running once

This makes it safe to run the seed file repeatedly without worrying about data integrity issues.

### Default Admin Account

The seeding creates a default admin account:
- **Email**: admin@skylark.com
- **Password**: password123
- **Role**: Super Admin

**⚠️ Important**: Change the default admin password in production!

## Deployment

### Render.com (Recommended)

This application is configured for easy deployment on Render.com using Docker.

#### Quick Deploy

1. **Fork or push** this repository to GitHub
2. **Connect to Render** and create a new Blueprint
3. **Set environment variables** (especially `RAILS_MASTER_KEY`)
4. **Deploy** - Render will handle the rest!

**Example**: This project is deployed at [https://skylark-3kbo.onrender.com/](https://skylark-3kbo.onrender.com/)

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

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support
Email projectskylark2025@gmail.com for support, comments, etc.
