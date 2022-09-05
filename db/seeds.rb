# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create!(name: "mhieu345",
            email: "lolicon1311@gmail.com",
            password: "131120",
            password_confirmation: "131120",
            admin: true,
            activated: true,
            activated_at: Time.zone.now)
  # Generate a bunch of additional users.
99.times do |n|
  name = Faker::Name.initials(number: 5)
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
              email: email,
              password: password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)
end
users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(word_count: 5)
  users.each { |user| user.micropost.create!(content: content) }
end
