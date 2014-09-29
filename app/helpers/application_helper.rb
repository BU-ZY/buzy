module ApplicationHelper
	def busyness_color(score)
    colors = {
      red: '#C4161B',
      orange: '#FAA419',
      green: '#74BF45',
      blue: '#007CC4',
      pink: '#FF0060'
    }

    case score # THESE COLORS SHOULD MATCH WITH CUSTOM.CSS
      when 0..33
        @color = colors[:green]
      when 34..66
        @color = colors[:orange]
      else
        @color = colors[:red]
    end
    @color
  end

  def places_and_colors
  	update_scores
  	@places_and_colors = []
    Place.all.each do |place| #refresh each place's scores
      @places_and_colors << [place, busyness_color(place.score)]
    end
    @places_and_colors
  end

  def update_scores
		Place.all.each do |place| #refresh each place's scores
      place.update_attribute(:score, score(place.votes))
    end
  end

  def votes_within(votes,time_ago)
    votes.select {|vote| ((time_ago/60).round.hour.ago) < vote[:created_at]}
  end

  def delete_old_votes
    Vote.where("created_at <= ?", Time.now - 1.hour).each{|vote| vote.destroy}
  end

  def recent_votes
    Vote.where("created_at >= ?", Time.now - 1.hour)
  end

  def score(which_votes=nil) #unless a time_ago in minutes is passed, scores all votes
    votes = which_votes ? which_votes : recent_votes.where(place_id: params[:id])
    score = votes.inject(0){|sum, v| sum += v.score}.to_f
    score /= votes.length unless score==0
    score.round
  end
end
