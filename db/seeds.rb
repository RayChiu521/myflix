# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

category1 = Category.create!(title: 'Action')
comedy = Category.create!(title: 'Comedy')

category1.videos.create!(title: 'MONK', description: "http://en.wikipedia.org/wiki/Monk_(TV_series)", small_cover_url: 'monk.jpg', large_cover_url: 'monk_large.jpg')
category1.videos.create!(title: 'futurama', description: "http://en.wikipedia.org/wiki/Futurama", small_cover_url: 'futurama.jpg', large_cover_url: 'futurama.jpg')
comedy.videos.create!(title: 'south park', description: "http://en.wikipedia.org/wiki/South_Park", small_cover_url: 'south_park.jpg', large_cover_url: 'south_park.jpg')
comedy.videos.create!(title: 'family guy', description: "http://en.wikipedia.org/wiki/Family_Guy", small_cover_url: 'family_guy.jpg', large_cover_url: 'family_guy.jpg')
category1.videos.create!(title: 'MONK', description: "http://en.wikipedia.org/wiki/Monk_(TV_series)", small_cover_url: 'monk.jpg', large_cover_url: 'monk_large.jpg')
category1.videos.create!(title: 'futurama', description: "http://en.wikipedia.org/wiki/Futurama", small_cover_url: 'futurama.jpg', large_cover_url: 'futurama.jpg')
category1.videos.create!(title: 'south park', description: "http://en.wikipedia.org/wiki/South_Park", small_cover_url: 'south_park.jpg', large_cover_url: 'south_park.jpg')
category1.videos.create!(title: 'family guy', description: "http://en.wikipedia.org/wiki/Family_Guy", small_cover_url: 'family_guy.jpg', large_cover_url: 'family_guy.jpg')
category1.videos.create!(title: 'south park', description: "http://en.wikipedia.org/wiki/South_Park", small_cover_url: 'south_park.jpg', large_cover_url: 'south_park.jpg')

henryk = User.create(email: 'henryk@example.com', full_name: 'henryk', password: 'pw')

friends = Video.create(category: comedy, title: 'Friends', description: "a tv sitcom.", small_cover_url: 'family_guy.jpg', large_cover_url: 'family_guy.jpg')

Review.create(creator: henryk, video: friends, rating: 5, content: "I like this show!")
Review.create(creator: henryk, video: friends, rating: 2, content: "But it's too long!")

huihong = User.create(email: 'huihong521@gmail.com', full_name: 'Hui Hong Chiu', password: 'pw')
ray = User.create(email: 'ray_s521@hotmail.com', full_name: 'Ray Chiu', password: 'pw')
david = User.create(email: 'david@example.com', full_name: 'David Wu', password: 'pw')


Followship.create(leader: huihong, follower: henryk)
Followship.create(leader: ray, follower: henryk)
Followship.create(leader: david, follower: henryk)