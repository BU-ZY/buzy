class StaticPagesController < ApplicationController
  def home
  	view_context.update_scores
  	@average_score = Place.all.map{|place| place.score}.instance_eval{(reduce(:+)/size.to_f)}.round
  	# @average_score = Place.all.map{|place| place.score}.inject(:+)/Place.all.length
  	@average_score = 1
  	@average_score_color = view_context.busyness_color(@average_score)
  end
end
