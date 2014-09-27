class StaticPagesController < ApplicationController
  def home
  	view_context.update_scores
  	@average_score = Place.all.map{|place| place.score}.instance_eval{reduce(:+)/size.to_f}.round
  	@average_score_color = view_context.busyness_color(@average_score)
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
