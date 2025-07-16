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

## Prerequisites

- Ruby 3.2.2
- PostgreSQL
- Node.js and Yarn
- Redis (optional)

## Installation

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
