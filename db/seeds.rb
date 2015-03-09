# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create! name: 'DT',   email: 'do0fusz@hotmail.com', password: 'developer', password_confirmation: 'developer', datenschutz: true
User.create! name: 'Ivan', email: 'ivan@lesslines.com',  password: 'developer', password_confirmation: 'developer', datenschutz: true
