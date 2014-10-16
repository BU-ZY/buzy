# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Example localhost reset and load seed data:
#     rake db:schema:load
#     rake db:seed

# Example Heroku reset and load seed data:
#     heroku pg:reset DATABASE
#     heroku run rake db:setup
# db:setup combines db:migrate and db:seed

# populate Places
file = File.open(File.join(Rails.root, 'app', 'assets', 'json', 'locations.json')).read
json = JSON.parse(file)
json.each do |p|
  if p['name'] != "CENTER"
    if Place.where(name: p['name']).length == 0 # just a double check to make sure we arent overwriting an existing place
      new_place = Place.new(name: p['name'], location: p['location'])
      new_place.tags = p['tags'] unless p['tags'].nil?
      new_place.save
    end
  end
end