puts "👥 Creating users..."

# Create a SuperAdmin User
admin = User.find_or_create_by!(email: "admin@skylark.com") do |user|
  user.first_name = "Admin"
  user.last_name = "User"
  user.password = "password123"
  user.super_admin = true
end

# Create regular users with realistic names and bios
users_data = [
  {
    first_name: "Sarah",
    last_name: "Johnson",
    email: "sarah.johnson@example.com",
    bio: "Full-stack developer passionate about open source and sustainable technology."
  },
  {
    first_name: "Michael",
    last_name: "Chen",
    email: "michael.chen@example.com",
    bio: "Data scientist specializing in machine learning and AI applications."
  },
  {
    first_name: "Emily",
    last_name: "Rodriguez",
    email: "emily.rodriguez@example.com",
    bio: "UX/UI designer focused on creating accessible and intuitive user experiences."
  },
  {
    first_name: "David",
    last_name: "Thompson",
    email: "david.thompson@example.com",
    bio: "DevOps engineer with expertise in cloud infrastructure and automation."
  },
  {
    first_name: "Lisa",
    last_name: "Park",
    email: "lisa.park@example.com",
    bio: "Product manager with a background in healthcare technology."
  },
  {
    first_name: "James",
    last_name: "Wilson",
    email: "james.wilson@example.com",
    bio: "Cybersecurity expert and ethical hacker."
  },
  {
    first_name: "Maria",
    last_name: "Garcia",
    email: "maria.garcia@example.com",
    bio: "Frontend developer specializing in React and modern web technologies."
  },
  {
    first_name: "Alex",
    last_name: "Brown",
    email: "alex.brown@example.com",
    bio: "Backend developer with experience in Ruby on Rails and PostgreSQL."
  }
]

users = [admin]
users_data.each do |user_data|
  user = User.find_or_create_by!(email: user_data[:email]) do |u|
    u.first_name = user_data[:first_name]
    u.last_name = user_data[:last_name]
    u.password = "password123"
    u.bio = user_data[:bio]
  end
  users << user
end

puts "🏢 Creating organizations..."

# Create organizations with realistic names
organizations_data = [
  {
    name: "TechCorp Solutions",
    description: "Leading technology consulting firm specializing in digital transformation."
  },
  {
    name: "GreenTech Innovations",
    description: "Sustainable technology company focused on environmental solutions."
  },
  {
    name: "HealthTech Labs",
    description: "Healthcare technology startup developing innovative medical solutions."
  },
  {
    name: "OpenSource Collective",
    description: "Community-driven organization promoting open source software development."
  },
  {
    name: "DataFlow Analytics",
    description: "Data analytics company providing insights for business intelligence."
  }
]

organizations = []
organizations_data.each do |org_data|
  org = Organization.find_or_create_by!(name: org_data[:name])
  organizations << org
end

puts "👥 Assigning users to organizations..."

# Assign users to organizations with realistic roles
organization_assignments = [
  { user: users[1], organization: organizations[0], role: :admin },    # Sarah -> TechCorp
  { user: users[2], organization: organizations[0], role: :member },   # Michael -> TechCorp
  { user: users[3], organization: organizations[1], role: :admin },    # Emily -> GreenTech
  { user: users[4], organization: organizations[1], role: :member },   # David -> GreenTech
  { user: users[5], organization: organizations[2], role: :admin },    # Lisa -> HealthTech
  { user: users[6], organization: organizations[2], role: :member },   # James -> HealthTech
  { user: users[7], organization: organizations[3], role: :admin },    # Maria -> OpenSource
  { user: users[8], organization: organizations[3], role: :member },   # Alex -> OpenSource
  { user: users[1], organization: organizations[4], role: :member },   # Sarah -> DataFlow (multiple orgs)
  { user: users[2], organization: organizations[4], role: :admin },    # Michael -> DataFlow (multiple orgs)
]

organization_assignments.each do |assignment|
  OrganizationMembership.find_or_create_by!(
    user: assignment[:user],
    organization: assignment[:organization]
  ) do |membership|
    membership.role = assignment[:role]
  end
end

puts "🏷️ Creating tags..."

# Create diverse tags
tags_data = [
  "Artificial Intelligence", "Machine Learning", "Data Science", "Cybersecurity",
  "Web Development", "Mobile Development", "DevOps", "Cloud Computing",
  "Blockchain", "IoT", "AR/VR", "Robotics", "Open Source", "API Development",
  "Database Design", "UI/UX Design", "Product Management", "Agile",
  "Sustainability", "Healthcare", "Education", "Finance", "E-commerce",
  "Social Media", "Gaming", "Music", "Video", "Photography", "Writing",
  "Research", "Testing", "Documentation", "Mentoring", "Community Building"
]

tags = {}
tags_data.each do |tag_name|
  tags[tag_name] = Tag.find_or_create_by!(name: tag_name)
end

puts "📂 Creating categories..."

# Create categories with descriptions
categories_data = [
  {
    name: "Technology",
    description: "Software development, programming, and technical projects"
  },
  {
    name: "Science & Research",
    description: "Scientific research, data analysis, and academic projects"
  },
  {
    name: "Environment & Sustainability",
    description: "Environmental protection, renewable energy, and sustainable solutions"
  },
  {
    name: "Healthcare & Medicine",
    description: "Medical technology, health applications, and wellness projects"
  },
  {
    name: "Education & Learning",
    description: "Educational tools, learning platforms, and knowledge sharing"
  },
  {
    name: "Creative & Arts",
    description: "Creative projects, digital arts, and multimedia content"
  },
  {
    name: "Business & Finance",
    description: "Business applications, financial tools, and enterprise solutions"
  },
  {
    name: "Community & Social",
    description: "Community building, social impact, and civic technology"
  }
]

categories = {}
categories_data.each do |category_data|
  categories[category_data[:name]] = Category.find_or_create_by!(name: category_data[:name]) do |category|
    category.description = category_data[:description]
  end
end

puts "🔗 Assigning tags to categories..."

# Assign relevant tags to each category
category_tag_assignments = {
  "Technology" => ["Web Development", "Mobile Development", "DevOps", "Cloud Computing", "API Development", "Database Design"],
  "Science & Research" => ["Data Science", "Machine Learning", "Artificial Intelligence", "Research", "Documentation"],
  "Environment & Sustainability" => ["Sustainability", "IoT", "GreenTech", "Research"],
  "Healthcare & Medicine" => ["Healthcare", "Artificial Intelligence", "Mobile Development", "Data Science"],
  "Education & Learning" => ["Education", "Web Development", "Mobile Development", "UI/UX Design", "Mentoring"],
  "Creative & Arts" => ["UI/UX Design", "AR/VR", "Gaming", "Music", "Video", "Photography"],
  "Business & Finance" => ["Finance", "E-commerce", "Product Management", "API Development", "Database Design"],
  "Community & Social" => ["Community Building", "Social Media", "Open Source", "Mentoring", "Documentation"]
}

categories.each do |category_name, category|
  tag_names = category_tag_assignments[category_name] || []
  tag_names.each do |tag_name|
    if tags[tag_name]
      CategoryTag.find_or_create_by!(category: category, tag: tags[tag_name])
    end
  end
end

puts "📋 Creating projects..."

# Create diverse projects with realistic content
projects_data = [
  {
    title: "EcoTracker - Environmental Monitoring Platform",
    summary: "A comprehensive platform for tracking environmental data and sustainability metrics.",
    description: "EcoTracker helps organizations monitor their environmental impact through real-time data collection, analysis, and reporting. Features include carbon footprint tracking, waste management analytics, and sustainability goal setting.",
    user: users[3], # Emily
    organization: organizations[1], # GreenTech
    visibility: :public,
    tags: ["Sustainability", "IoT", "Data Science", "Web Development"]
  },
  {
    title: "HealthAI - Medical Diagnosis Assistant",
    summary: "AI-powered medical diagnosis support system for healthcare professionals.",
    description: "HealthAI uses machine learning algorithms to assist doctors in diagnosing diseases based on symptoms, medical history, and test results. The system provides confidence scores and treatment recommendations.",
    user: users[5], # Lisa
    organization: organizations[2], # HealthTech
    visibility: :public,
    tags: ["Healthcare", "Artificial Intelligence", "Machine Learning", "Data Science"]
  },
  {
    title: "CodeMentor - Programming Education Platform",
    summary: "Interactive platform for learning programming with real-time feedback.",
    description: "CodeMentor provides personalized programming tutorials, interactive coding challenges, and real-time code review. Features include AI-powered code analysis, peer mentoring, and progress tracking.",
    user: users[7], # Maria
    organization: organizations[3], # OpenSource
    visibility: :public,
    tags: ["Education", "Web Development", "Artificial Intelligence", "Mentoring"]
  },
  {
    title: "SecureNet - Cybersecurity Framework",
    summary: "Comprehensive cybersecurity framework for enterprise applications.",
    description: "SecureNet provides a complete security solution including threat detection, vulnerability assessment, and incident response. Built with modern security practices and compliance standards.",
    user: users[6], # James
    organization: nil, # Independent project
    visibility: :public,
    tags: ["Cybersecurity", "DevOps", "Testing", "Documentation"]
  },
  {
    title: "DataViz Pro - Business Intelligence Dashboard",
    summary: "Advanced data visualization and business intelligence platform.",
    description: "DataViz Pro transforms complex data into actionable insights through interactive dashboards, automated reporting, and predictive analytics. Supports multiple data sources and real-time updates.",
    user: users[1], # Sarah
    organization: organizations[4], # DataFlow
    visibility: :public,
    tags: ["Data Science", "Web Development", "Business Intelligence", "API Development"]
  },
  {
    title: "CloudDeploy - Infrastructure Automation Tool",
    summary: "Automated cloud infrastructure deployment and management platform.",
    description: "CloudDeploy simplifies cloud infrastructure management with automated provisioning, scaling, and monitoring. Supports multiple cloud providers and includes cost optimization features.",
    user: users[4], # David
    organization: organizations[0], # TechCorp
    visibility: :public,
    tags: ["Cloud Computing", "DevOps", "Automation", "API Development"]
  },
  {
    title: "ArtFlow - Digital Art Creation Platform",
    summary: "Collaborative digital art creation and sharing platform.",
    description: "ArtFlow enables artists to create, collaborate, and share digital artwork. Features include real-time collaboration, AI-powered art suggestions, and NFT integration.",
    user: users[8], # Alex
    organization: nil, # Independent project
    visibility: :public,
    tags: ["Creative & Arts", "Web Development", "AR/VR", "Blockchain"]
  },
  {
    title: "EduConnect - Student-Teacher Communication Platform",
    summary: "Platform for seamless communication between students and teachers.",
    description: "EduConnect facilitates effective communication between students and teachers through messaging, assignment tracking, and progress monitoring. Includes features for parent involvement and academic analytics.",
    user: users[2], # Michael
    organization: nil, # Independent project
    visibility: :public,
    tags: ["Education", "Mobile Development", "UI/UX Design", "Social Media"]
  },
  {
    title: "FinTech Hub - Financial Technology Solutions",
    summary: "Comprehensive financial technology platform for small businesses.",
    description: "FinTech Hub provides payment processing, accounting automation, and financial analytics for small businesses. Includes features for invoicing, expense tracking, and financial reporting.",
    user: users[1], # Sarah
    organization: organizations[0], # TechCorp
    visibility: :private,
    tags: ["Finance", "E-commerce", "API Development", "Database Design"]
  },
  {
    title: "CommunityBuilder - Civic Engagement Platform",
    summary: "Platform for building and managing local community initiatives.",
    description: "CommunityBuilder helps local communities organize events, share resources, and coordinate volunteer efforts. Features include event management, resource sharing, and community analytics.",
    user: users[3], # Emily
    organization: organizations[1], # GreenTech
    visibility: :public,
    tags: ["Community Building", "Web Development", "Mentoring"]
  }
]

projects = []
projects_data.each do |project_data|
  project = Project.find_or_initialize_by(
    title: project_data[:title],
    user: project_data[:user],
  ) do |p|
    p.summary = project_data[:summary]
    p.description = project_data[:description]
    p.organization = project_data[:organization]
    p.visibility = project_data[:visibility] || :public
    
    p.save!
  end
  
  # Assign tags to project
  project_data[:tags].each do |tag_name|
    if tags[tag_name]
      ProjectTag.find_or_create_by!(project: project, tag: tags[tag_name])
    end
  end
  
  projects << project
end

puts "👥 Creating project memberships..."

# Create project memberships with realistic scenarios
membership_scenarios = [
  { project: projects[0], user: users[2], status: :approved, message: "Interested in contributing to environmental monitoring features." },
  { project: projects[0], user: users[4], status: :approved, message: "Can help with IoT integration and data collection." },
  { project: projects[1], user: users[6], status: :approved, message: "Experienced in healthcare security and compliance." },
  { project: projects[1], user: users[8], status: :pending, message: "Would like to contribute to the frontend development." },
  { project: projects[2], user: users[1], status: :approved, message: "Can help with backend development and API design." },
  { project: projects[2], user: users[5], status: :approved, message: "Interested in contributing to the educational content." },
  { project: projects[3], user: users[4], status: :approved, message: "Can help with DevOps and deployment automation." },
  { project: projects[4], user: users[2], status: :approved, message: "Experienced in data visualization and analytics." },
  { project: projects[5], user: users[6], status: :approved, message: "Can contribute to security features and compliance." },
  { project: projects[6], user: users[7], status: :approved, message: "Interested in contributing to the UI/UX design." },
  { project: projects[7], user: users[3], status: :approved, message: "Can help with mobile app development." },
  { project: projects[8], user: users[2], status: :pending, message: "Would like to contribute to financial analytics features." },
  { project: projects[9], user: users[5], status: :approved, message: "Can help with community engagement features." }
]

membership_scenarios.each do |scenario|
  ProjectMembership.find_or_create_by!(
    project: scenario[:project],
    user: scenario[:user]
  ) do |membership|
    membership.status = scenario[:status]
    membership.request_message = scenario[:message]
  end
end

puts "📝 Creating project notes..."

# Create project notes with realistic content
note_templates = [
  {
    title: "Project Kickoff Meeting",
    content: "Initial project planning session completed. Key milestones identified and team roles assigned. Next steps include setting up development environment and creating project timeline.",
    entry_type: :report
  },
  {
    title: "Technical Architecture Review",
    content: "Reviewed the proposed technical architecture. Decided to use microservices approach for better scalability. Database schema design approved with minor modifications.",
    entry_type: :report
  },
  {
    title: "User Feedback Integration",
    content: "Collected feedback from beta users. Main concerns about performance and user interface complexity. Planning to address these issues in the next sprint.",
    entry_type: :comment
  },
  {
    title: "Security Audit Results",
    content: "Completed security audit. Found several minor vulnerabilities that have been addressed. No critical security issues identified. Ready for production deployment.",
    entry_type: :report
  },
  {
    title: "Performance Optimization",
    content: "Implemented caching layer and database query optimization. Performance improved by 40%. Monitoring shows stable response times under load.",
    entry_type: :comment
  },
  {
    title: "API Documentation Update",
    content: "Updated API documentation with new endpoints. Added code examples and improved error handling documentation. Ready for developer onboarding.",
    entry_type: :report
  },
  {
    title: "Testing Strategy Discussion",
    content: "Discussed testing approach for the new features. Decided to implement comprehensive unit tests and integration tests. Automated testing pipeline to be set up next week.",
    entry_type: :comment
  },
  {
    title: "Deployment Planning",
    content: "Planning production deployment for next week. Will use blue-green deployment strategy to minimize downtime. Rollback plan prepared in case of issues.",
    entry_type: :report
  }
]

projects.each do |project|
  # Create 2-4 notes per project, but only if the project doesn't already have notes
  if project.notes.count == 0
    rand(2..4).times do
      template = note_templates.sample
      ProjectNote.create!(
        project: project,
        user: project.memberships.approved.map(&:user).sample || project.user,
        title: template[:title],
        content: template[:content],
        entry_type: template[:entry_type]
      )
    end
  end
end

puts "📧 Creating information requests..."

# Create information requests for some projects
information_request_templates = [
  {
    title: "Technical Documentation Request",
    description: "I'm interested in understanding the technical architecture and implementation details of this project. Could you provide documentation on the system design, API specifications, and deployment process?"
  },
  {
    title: "Collaboration Inquiry",
    description: "I have experience in similar technologies and would like to contribute to this project. What areas need the most help, and what is the process for getting involved?"
  },
  {
    title: "Integration Questions",
    description: "I'm working on a related project and would like to understand how this system could integrate with our existing infrastructure. What are the integration requirements and APIs available?"
  },
  {
    title: "Deployment Support",
    description: "I'm trying to deploy this project in my environment but encountering some issues. Could you provide guidance on the deployment process and common troubleshooting steps?"
  },
  {
    title: "Feature Request Discussion",
    description: "I have some ideas for additional features that could enhance this project. Would you be interested in discussing these ideas and potentially collaborating on implementation?"
  }
]

# Create information requests for public projects (only if they don't already have requests)
public_projects_without_requests = projects.select { |p| p.visibility == :public && p.information_requests.count == 0 }
public_projects_without_requests.sample([5, public_projects_without_requests.length].min).each do |project|
  template = information_request_templates.sample
  request = InformationRequest.create!(
    project: project,
    user: users.sample,
    title: template[:title],
    description: template[:description],
    expires_at: 30.days.from_now
  )
  
  # Add some responses to information requests
  if rand < 0.7
    rand(1..3).times do
      InformationRequestResponse.create!(
        information_request: request,
        content: "Thank you for your interest! I'd be happy to help with that. Let me provide some additional details and documentation."
      )
    end
  end
end

puts "🔔 Creating notifications..."

# Create notifications for various events
notification_templates = [
  "New member joined your project: {project_title}",
  "You received a new information request for: {project_title}",
  "Project membership request was approved for: {project_title}",
  "New note added to project: {project_title}",
  "Your information request received a response",
  "Project {project_title} has been updated with new features",
  "You have been assigned as admin for organization: {org_name}",
  "New project created in your organization: {project_title}"
]

# Create notifications for users (only if they don't already have many notifications)
users.each do |user|
  if user.notifications.count < 3
    rand(2..5).times do
      template = notification_templates.sample
      message = template.gsub("{project_title}", projects.sample.title)
                       .gsub("{org_name}", organizations.sample.name)
      
      # Only create if this exact notification doesn't already exist
      unless user.notifications.exists?(message: message)
        Notification.create!(
          user: user,
          notifiable: [projects.sample, organizations.sample].sample,
          message: message,
          read: rand < 0.3
        )
      end
    end
  end
end

puts "✅ Database seeded successfully!"
puts ""
puts "📊 Summary:"
puts "  👥 Users: #{User.count} (including #{User.where(super_admin: true).count} super admin)"
puts "  🏢 Organizations: #{Organization.count}"
puts "  📋 Projects: #{Project.count}"
puts "  🏷️ Tags: #{Tag.count}"
puts "  📂 Categories: #{Category.count}"
puts "  📝 Project Notes: #{ProjectNote.count}"
puts "  📧 Information Requests: #{InformationRequest.count}"
puts "  🔔 Notifications: #{Notification.count}"
puts ""
puts "🔑 Login Credentials:"
puts "  Super Admin: admin@skylark.com / password123"
puts "  Regular Users: [firstname].[lastname]@example.com (e.g. alex.brown@example.com) / password123"
puts ""
puts "🎉 Your Skylark application is ready with comprehensive seed data!"
puts "💡 This seed file is safe to run multiple times - it only creates missing records!"