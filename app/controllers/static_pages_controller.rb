class StaticPagesController < ApplicationController
  include ApplicationHelper
  
  def home
  	update_scores
  	@average_score = Place.all.map{|place| place.score}.instance_eval{(reduce(:+)/size.to_f)}.round
  	@average_score_color = view_context.busyness_color(@average_score)
    @places_and_colors = places_and_colors
  end

  def map
  	update_scores
  	file = File.open(File.join(Rails.root, 'app', 'assets', 'json', 'locations.json')).read
  	json = JSON.parse(file)
  	@center_lat = json.find{|p| p['name'] == 'CENTER'}['lat'] # find center of map
  	@center_long = json.find{|p| p['name'] == 'CENTER'}['long'] 
  	selection = Place.all.select{|p| !p.location.nil? && p.location != "" && p.name!= "CENTER"} # find all the actual places
  	@addresses = selection.map{|p| p.location.gsub(" ","").split(",")} # 2d array of [lat,long]
  	@scores = selection.map{|p| p.score.to_s}
  	@names = selection.map{|p| p.name}
  	render 'map'
  end

end
