class PlacesController < ApplicationController
  include SessionsHelper
  include ApplicationHelper
  # ***DISABLING SIGN IN FOR DEV***
  #before_action :signed_in_user, only: [:new]

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

  def votes_within(votes,time_ago)
    votes.select {|vote| ((time_ago/60).round.hour.ago) < vote[:created_at] }
  end

  def score(which_votes=nil) #unless a time_ago in minutes is passed, scores all votes
    delete_old_votes
    now = Time.new

    votes = which_votes ? which_votes : Vote.where(place_id: params[:id])

    past_votes = votes.select{|vote| vote.created_at <= (Time.now - 5.minutes)}
    recent_votes = votes.select{|vote| vote.created_at >= (Time.now - 5.minutes)}

    recent_avg = recent_votes.inject(0){|sum, v| sum += v.score}.to_f
    recent_avg /= recent_votes.length unless recent_avg==0
    past_avg = past_votes.inject(0){|sum, v| sum += v.score}.to_f
    past_avg /= past_votes.length unless past_avg==0

    if past_votes.empty? && recent_votes.empty?
      return 50
    elsif past_votes.empty?
      return recent_avg
    elsif recent_votes.empty?
      return past_avg
    elsif !past_votes.empty? && !recent_votes.empty?
      return (past_avg + recent_avg)/2    
    end
  end

  def score2(votes) #unless a time_ago in minutes is passed, scores all votes
    
    now = Time.new
  
    total_time_ago = 0 
    votes.each do |vote| #total times ago
      total_time_ago += now - vote.created_at
    end
    
    @total = 0
    votes.each do |vote| #calc weighted average
      time_ago = (now-vote.created_at)
      #@total += (vote.score*(time_ago/total_time_ago)).round
      @total += (vote.score)
    end
    @total 
  end

  def new
  	@place = Place.new
  end

  def graphable_votes(votes)
    votes.map { |x| [x.created_at, x.score]}
  end

  def show
    @place = Place.find(params[:id])
    @time_ago = params[:time_ago] ? params[:time_ago].to_i : 60
    unless @place.votes.blank?
      votes = !@time_ago.blank? ? view_context.votes_within(@place.votes, @time_ago) : @place.votes
      @score = score(@place.votes)
      @color = busyness_color(@score)
      @graphable  = graphable_votes(votes)
      # ***DISABLING USER TRACKING FOR DEV*** <- damn you
      #@username = current_user.name
      @username = "Public"
    end
  end

  def create
    if Place.where(:name => place_params[:name]).blank? #check if a place with that name exists
      @place = Place.new(place_params)
      if @place.save
        redirect_to @place
      else
        render 'new'
      end
    else
      @name = place_params[:name]
      render 'place_exists_with_name'
    end
  end

  def index
    @places = Place.all
    @places_and_colors = []
    @places.each do |place| #refresh each place's scores
     # place.score = score(votes_within(place.votes, 60))
      place.score = score(place.votes)
      @places_and_colors << [place, busyness_color(place.score)]
    end
    @places_and_colors = places_and_colors
  end

  private

    def place_params
      #params.require(:place).permit(:name, :longitude, :latitude)
      params.require(:place).permit(:name)
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

end

