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
      place.update_attribute(:score, score(place.votes))
    end
  end

  def votes_within(votes,time_ago)
    votes.select {|vote| ((time_ago/60).round.hour.ago) < vote[:created_at]}
  end

  def delete_old_votes
    Vote.where("created_at <= ?", Time.now - 1.hour).each{|vote| vote.destroy}
  end

  def score(id=nil, opts={}) #unless a time_ago in minutes is passed, scores all votes
    delete_old_votes
    now = Time.new

    votes = opts[:which_votes] ? opts[:which_votes] : Vote.where(place_id: id)
    past_votes = votes.select{|vote| vote.created_at <= (Time.now - 5.minutes)}
    recent_votes = votes.select{|vote| vote.created_at >= (Time.now - 5.minutes)}

    recent_avg = recent_votes.inject(0){|sum, v| sum += v.score}.to_f
    recent_avg /= recent_votes.length unless recent_avg==0
    past_avg = past_votes.inject(0){|sum, v| sum += v.score}.to_f
    past_avg /= past_votes.length unless past_avg==0

    if past_votes.empty? && recent_votes.empty?
      score = 50
    elsif past_votes.empty?
      score = recent_avg
    elsif recent_votes.empty?
      score = past_avg
    elsif !past_votes.empty? && !recent_votes.empty?
      score = (past_avg + recent_avg)/2    
    end

    score.round
  end
end
