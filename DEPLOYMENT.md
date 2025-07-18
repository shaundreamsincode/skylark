# Deployment Guide for Skylark on Render.com

This guide covers deploying your dockerized Skylark application to Render.com.

## Prerequisites

1. **Render.com Account** - Sign up at [render.com](https://render.com)
2. **GitHub Repository** - Your code should be in a GitHub repo
3. **Rails Master Key** - You'll need your Rails master key

## Option 1: Blueprint Deployment (Recommended)

### Step 1: Connect Your Repository

1. Go to your Render dashboard
2. Click "New +" → "Blueprint"
3. Connect your GitHub repository
4. Select the repository containing your Skylark app

### Step 2: Configure Blueprint

1. Render will automatically detect the `render.yaml` file
2. Review the configuration:
   - **Web Service**: Your Rails application
   - **PostgreSQL Database**: For data storage
   - **Redis Service**: For caching and sessions

### Step 3: Set Environment Variables

You'll need to set these in the Render dashboard:

- `RAILS_MASTER_KEY`: Your Rails master key (from `config/master.key`)

### Step 4: Deploy

1. Click "Apply" to start the deployment
2. Render will:
   - Create the PostgreSQL database
   - Create the Redis service
   - Build and deploy your Docker container
   - Run database migrations automatically

## Option 2: Manual Service Creation

If you prefer to create services manually:

### Step 1: Create PostgreSQL Database

1. Go to "New +" → "PostgreSQL"
2. Name: `skylark-db`
3. Database: `skylark_production`
4. User: `skylark`
5. Plan: Choose based on your needs (Free tier available)

### Step 2: Create Redis Service

1. Go to "New +" → "Redis"
2. Name: `skylark-redis`
3. Plan: Choose based on your needs (Free tier available)

### Step 3: Create Web Service

1. Go to "New +" → "Web Service"
2. Connect your GitHub repository
3. Configure:
   - **Name**: `skylark-web`
   - **Environment**: `Docker`
   - **Dockerfile Path**: `./Dockerfile.production`
   - **Build Command**: Leave empty (uses Dockerfile)
   - **Start Command**: Leave empty (uses Dockerfile)

### Step 4: Set Environment Variables

In your web service settings, add these environment variables:

```
RAILS_ENV=production
RAILS_MASTER_KEY=your_master_key_here
DATABASE_URL=postgresql://skylark:password@your-db-host:5432/skylark_production
REDIS_URL=redis://your-redis-host:6379/1
RAILS_SERVE_STATIC_FILES=true
RAILS_LOG_TO_STDOUT=true
```

## Environment Variables

### Required Variables

- `RAILS_ENV`: Set to `production`
- `RAILS_MASTER_KEY`: Your Rails master key
- `DATABASE_URL`: PostgreSQL connection string (auto-provided by Render)
- `REDIS_URL`: Redis connection string (auto-provided by Render)

### Optional Variables

- `RAILS_SERVE_STATIC_FILES`: `true` (for serving assets)
- `RAILS_LOG_TO_STDOUT`: `true` (for Render logging)
- `PORT`: Automatically set by Render

## Health Checks

Your application includes a health check endpoint at `/health` that returns:
- `200 OK` when the application is healthy
- Used by Render for automatic health monitoring

## Monitoring

### Logs
- View logs in the Render dashboard
- Logs are automatically collected from stdout/stderr

### Metrics
- Monitor CPU, memory, and disk usage
- Set up alerts for resource usage

## Scaling

### Automatic Scaling
- Enable auto-scaling based on CPU/memory usage
- Set minimum and maximum instances

### Manual Scaling
- Scale up/down manually in the dashboard
- Useful for predictable traffic patterns

## Custom Domains

1. Go to your web service settings
2. Click "Custom Domains"
3. Add your domain
4. Configure DNS records as instructed

## SSL/TLS

- Automatic SSL certificates provided by Render
- HTTPS enabled by default
- Force HTTPS redirect recommended

## Troubleshooting

### Common Issues

#### Build Failures
- Check build logs in Render dashboard
- Ensure all dependencies are in Dockerfile
- Verify Dockerfile syntax

#### Database Connection Issues
- Verify `DATABASE_URL` environment variable
- Check database service is running
- Ensure migrations run successfully

#### Asset Compilation Issues
- Check if assets are precompiled in Dockerfile
- Verify `RAILS_SERVE_STATIC_FILES=true`

#### Memory Issues
- Increase memory allocation in service settings
- Optimize Docker image size
- Monitor memory usage in logs

### Debug Commands

```bash
# Check service status
curl https://your-app.onrender.com/health

# View logs
# Use Render dashboard or CLI

# Check environment variables
# Available in service settings
```

## Performance Optimization

### Docker Image Optimization
- Multi-stage builds reduce image size
- Alpine Linux base image
- Only production dependencies included

### Database Optimization
- Use connection pooling
- Optimize queries
- Monitor slow queries

### Caching
- Redis for session storage
- Fragment caching
- CDN for static assets

## Security

### Environment Variables
- Never commit secrets to Git
- Use Render's environment variable management
- Rotate keys regularly

### Database Security
- Use strong passwords
- Enable SSL connections
- Regular backups

### Application Security
- Keep dependencies updated
- Use HTTPS everywhere
- Implement proper authentication

## Backup Strategy

### Database Backups
- Render provides automatic PostgreSQL backups
- Configure backup retention
- Test restore procedures

### Application Backups
- Code is backed up in Git
- Environment variables in Render
- Consider external backup for critical data

## Cost Optimization

### Free Tier Usage
- PostgreSQL: 1GB storage, 90 days retention
- Redis: 256MB storage
- Web Service: 750 hours/month

### Paid Plans
- Scale based on actual usage
- Monitor resource consumption
- Use auto-scaling for cost efficiency 