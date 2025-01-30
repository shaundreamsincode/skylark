# Seeds

require 'faker'

puts "Seeding database..."

user = User.create!(
  first_name: "Shaun",
  last_name: "Carland",
  email: "shaun@gmail.com",
  password: "password",
  password_confirmation: "password"
) # todo make password more secure...

collaborator_role = Role.find_or_create_by!(name: :collaborator)
sponsor_role = Role.find_or_create_by!(name: :sponsor)

sponsor_user_role = UserRole.find_or_create_by!(role: sponsor_role, user: user)

#
# # Create Roles
# sponsor_role = Role.find_or_create_by!(name: :sponsor)
# investigator_role = Role.find_or_create_by!(name: :investigator)
#
# # Create Users
# sponsors = 3.times.map do
#   user = User.create!(
#     name: Faker::Name.name,
#     email: Faker::Internet.email,
#     password: "password"
#   )
#   UserRole.create!(user: user, role: sponsor_role)
#   user
# end
#
# investigators = 5.times.map do
#   user = User.create!(
#     name: Faker::Name.name,
#     email: Faker::Internet.email,
#     password: "password"
#   )
#   UserRole.create!(user: user, role: investigator_role)
#   user
# end
#
# # Create Research Projects
# projects = sponsors.map do |sponsor|
#   ResearchProject.create!(
#     title: Faker::Science.science,
#     summary: Faker::Lorem.sentence,
#     description: Faker::Lorem.paragraph,
#     sponsor: sponsor
#   )
# end
#
# # Create Participation Requests
# projects.each do |project|
#   investigators.sample(3).each do |investigator|
#     ResearchProjectParticipationRequest.create!(
#       research_project: project,
#       investigator: investigator,
#       status: %w[pending accepted rejected].sample
#     )
#   end
# end
#
# # Create Participation Notes
# projects.each do |project|
#   project.participation_requests.accepted.each do |request|
#     CollaboratorNote.create!(
#       research_project: project,
#       user: request.investigator,
#       entry_type: CollaboratorNote.entry_types.keys.sample,
#       content: Faker::Lorem.paragraph
#     )
#   end
# end
#
# puts "Seeding complete!"
