module ApplicationHelper

  include FontAwesome::Rails::IconHelper # for using fontawesome
  include ActionView::Helpers::TagHelper # for using fontawesome

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

  def busyness_name(score)
    case score # THESE COLORS SHOULD MATCH WITH CUSTOM.
      when nil
        "Nil prediction!"
      when 0..25
        "Not busy"
      when 26..50
        "Slightly busy"
      when 51..75
        "Busy"
      when 76..100
        "Buzzing!"
      else
        "ERROR: score out of range"
    end
  end

  def update_scores(id=nil) # updates the score of all places by default, or just the place with the passed id
    places = id ? [Place.find(id)] : Place.all
    places.each do |place| #refresh each place's scores
      if place.votes.empty?
        place.update_attribute(:score, nil)
      else
        place.update_attribute(:score, weighted_score(place.votes))
      end
    end
  end

  def delete_old_votes
    Vote.where("created_at <= ?", Time.now - 1.hour).each{|vote| vote.destroy}
  end

  def votes_within(minutes, id=nil) # returns an array of Votes within the last m minutes
    votes = id ? Vote.where(place_id: id) : Vote.all
    votes.where("created_at >= ?", Time.now - minutes.minutes)
  end

  def recent_votes # arbitrary decision to return all votes within past hour
    votes_within(60)
  end

   def weighted_score(which_votes=nil) # scores an array of votes if one is passed, otherwise scores just the place with current id
    votes = which_votes ? which_votes : recent_votes.where(place_id: params[:id])
    return nil if votes.empty?
    total_length = 0
    total_sum = 0
    votes.each do |vote|
      if vote.within?(5) # vote within last 5 minutes
        # weight x5
        total_length += 5
        total_sum += vote.score*5
      else # no weight
        total_length += 1
        total_sum += vote.score
      end
    end
    return total_sum/total_length
  end
end
