# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

@user = User.create!(
    name: 'Hiroaki',
    email: 'hiroaki@gmail.com',
    password: '012345',
    admin: false
)

@admin_user = User.create!(
    name: 'Yuki',
    email: 'yuki@gmail.com',
    password: '012345',
    admin: true
)

50.times do |n|
    date = Date.today+n+1
    Task.create!(
        tittle: "task_tittle_#{n + 1}",
        content: "task_content_#{n + 1}",
        deadline_on: date,
        priority: rand(3),
        status: rand(3),
        user_id: @user.id
    )
end

50.times do |n|
    date = Date.today+n+1
    Task.create!(
        tittle: "task_tittle_#{n + 1}",
        content: "task_content_#{n + 1}",
        deadline_on: date,
        priority: rand(3),
        status: rand(3),
        user_id: @admin_user.id
    )
end