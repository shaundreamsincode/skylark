# Clear existing data
ProjectTag.destroy_all
ProjectMembership.destroy_all
ProjectNote.destroy_all
# ProjectNotification.destroy_all
Project.destroy_all
OrganizationMembership.destroy_all
Organization.destroy_all
User.destroy_all
Category.destroy_all
Tag.destroy_all
CategoryTag.destroy_all

# Create a SuperAdmin User
User.create!(
  first_name: "Admin",
  last_name: "User",
  email: "admin@example.com",
  password: "password",
  super_admin: true
)

# Create Users
users = []
5.times do |i|
  users << User.create!(
    first_name: "User#{i+1}",
    last_name: "Test",
    email: "user#{i+1}@example.com",
    password: "password",
    bio: "Bio for User#{i+1}"
  )
end

# Create Organizations
organizations = []
3.times do |i|
  organizations << Organization.create!(name: "Organization #{i+1}")
end

# Assign Users to Organizations
users.each do |user|
  OrganizationMembership.create!(
    user: user,
    organization: organizations.sample,
    role: %i[member admin].sample
  )
end

# Create Tags
tags = {}
["AI", "Machine Learning", "Data Science", "Cybersecurity", "Web Development", "Open Source"].each do |tag_name|
  tags[tag_name] = Tag.create!(name: tag_name)
end

# Create Categories
categories = {}
["Technology", "Science", "Environment", "Education"].each do |category_name|
  categories[category_name] = Category.create!(name: category_name)
end

# Assign Tags to Categories (Avoid Duplicates)
categories.values.each do |category|
  selected_tags = tags.values.sample(2)
  selected_tags.each do |tag|
    CategoryTag.find_or_create_by!(category: category, tag: tag)
  end
end

# Create Projects
projects = []
8.times do |i|
  projects << Project.create!(
    title: "Project #{i+1}",
    summary: "Summary for Project #{i+1}",
    description: "Description for Project #{i+1}",
    user: users.sample,
    organization: [organizations.sample, nil].sample, # Some projects belong to orgs, some are independent
    visibility: [0, 1].sample
  )
end

# Assign Tags to Projects (Avoid Duplicates)
projects.each do |project|
  selected_tags = tags.values.sample(2)
  selected_tags.each do |tag|
    ProjectTag.find_or_create_by!(project: project, tag: tag)
  end
end

# Create Project Memberships
projects.each do |project|
  2.times do
    ProjectMembership.create!(
      project: project,
      user: users.sample,
      status: :approved,
      request_message: "I want to join this project!"
    )
  end
end

# Create Project Notes
projects.each do |project|
  2.times do
    ProjectNote.create!(
      project: project,
      user: users.sample,
      title: "Project Note",
      content: "This is a sample note for project #{project.title}.",
      entry_type: %i[report comment].sample
    )
  end
end

# # Create Project Notifications
# projects.each do |project|
#   ProjectNotification.create!(
#     project: project,
#     message: "New update on #{project.title}!"
#   )
# end

puts "✅ Database seeded successfully!"