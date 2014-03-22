module CalcBusynessColor
	def busyness_color(score)
		case score
			when 0..33
				@color = '#66CC00'
			when 34..66
				@color = '#FFFF33'
			else
				@color = '#FF0000'
		end
	end
	@color
end