# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create!(title: 'MONK', description: "http://en.wikipedia.org/wiki/Monk_(TV_series)", small_cover_url: 'monk.jpg', large_cover_url: 'monk_large.jpg')
Video.create!(title: 'futurama', description: "http://en.wikipedia.org/wiki/Futurama", small_cover_url: 'futurama.jpg', large_cover_url: 'futurama.jpg')
Video.create!(title: 'south park', description: "http://en.wikipedia.org/wiki/South_Park", small_cover_url: 'south_park.jpg', large_cover_url: 'south_park.jpg')
Video.create!(title: 'family guy', description: "http://en.wikipedia.org/wiki/Family_Guy", small_cover_url: 'family_guy.jpg', large_cover_url: 'family_guy.jpg')