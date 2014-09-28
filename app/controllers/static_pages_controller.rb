class StaticPagesController < ApplicationController
  include ApplicationHelper
  
  def home
  	view_context.update_scores
  	@average_score = Place.all.map{|place| place.score}.instance_eval{(reduce(:+)/size.to_f)}.round
  	# @average_score = Place.all.map{|place| place.score}.inject(:+)/Place.all.length
  	@average_score = 1
  	@average_score_color = view_context.busyness_color(@average_score)
    @places_and_colors = places_and_colors
  end

  def map
  	file = File.open(File.join(Rails.root, 'app', 'assets', 'json', 'locations.json')).read
  	@json = JSON.parse(file)
  	@addresses = @json.map{|e| e['address']}
  	@address_array = @json.map{|e| e['address']}.join("','").prepend("'")<< ("'")
  	@address_array2 = eval(@json.map{|e| "#{e['address']}"}.to_s)
  	@json_array = @json.map{|e| e['address']}.to_json
  	raise "hi"
  	render 'map'
  end

end
