module ApplicationHelper
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
      #place.update_attribute(:score, score(votes_within(place.votes, 60)))
      place.update_attribute(:score, score(place.votes))
    end
  end

  def votes_within(votes,time_ago)
    votes.select {|vote| ((time_ago/60).round.hour.ago) < vote[:created_at]}
  end

  def score(votes) #calculates a time-weighted average of a set of votes
    now = Time.new
  
    total_time_ago = 0 
    votes.each do |vote| #total times ago
      total_time_ago += now - vote.created_at
    end
    
    @total = 0
    votes.each do |vote| #calc weighted average
      time_ago = (now-vote.created_at)
      @total += (vote.score*((total_time_ago-time_ago+1)/total_time_ago)).round #weight more recent votes more
    end
    votes.length>0 ? @total/votes.length : 50 #return an average, 50 by default
  end
end
