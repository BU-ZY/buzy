module PlacesHelper
	def busyness_color(score)
		case score
			when 0..33
				@color = '#66CC00'
			when 34..66
				@color = '#FF9933'
			else
				@color = '#FF0000'
		end
		@color
	end

	def avg_score(place)
		@total = 0
		place.votes.each do |vote|
	      @total += vote.score
	    end
	    @average = @total/place.votes.length
	end
end