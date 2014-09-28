class MakePlacesFromJson < ActiveRecord::Migration
  def change
  	file = File.open(File.join(Rails.root, 'app', 'assets', 'json', 'locations.json')).read
  	json = JSON.parse(file)
  	json.each do |p|
  		Place.create(name: p['name'], location:p['location']) unless p['name'] == "CENTER"
  	end
  end
end
