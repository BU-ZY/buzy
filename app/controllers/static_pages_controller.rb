class StaticPagesController < ApplicationController
  include ApplicationHelper
  
  def home
  	view_context.update_scores
  	@average_score = Place.all.map{|place| place.score}.instance_eval{(reduce(:+)/size.to_f)}.round
  	@average_score_color = view_context.busyness_color(@average_score)
    @places_and_colors = places_and_colors
  end

  def map
  	file = File.open(File.join(Rails.root, 'app', 'assets', 'json', 'locations.json')).read
  	json = JSON.parse(file)
  	@center_lat = json.find{|p| p['name'] == 'CENTER'}['lat']
  	@center_long = json.find{|p| p['name'] == 'CENTER'}['long']
  	@locations = Place.all.select{|p| p.location != ""}.map{|p| p.location}
  	render 'map'
  end

end
