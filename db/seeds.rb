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
