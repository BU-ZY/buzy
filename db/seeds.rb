# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


# populate Places
file = File.open(File.join(Rails.root, 'app', 'assets', 'json', 'locations.json')).read
json = JSON.parse(file)
json.each do |p|
	Place.create(name: p['name'], location:p['location']) unless p['name'] == "CENTER"
end