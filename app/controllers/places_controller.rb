class PlacesController < ApplicationController
  include SessionsHelper
  # ***DISABLING SIGN IN FOR DEV***
  #before_action :signed_in_user, only: [:new]

<<<<<<< HEAD
=======
<<<<<<< HEAD
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

  def score(votes) #unless a time_ago in minutes is passed, scores all votes
    now = Time.new
  
    total_time_ago = 0 
    votes.each do |vote| #total times ago
      total_time_ago += now - vote.created_at
    end
    
    @total = 0
    votes.each do |vote| #calc weighted average
      time_ago = (now-vote.created_at)
      @total += (vote.score*(time_ago/total_time_ago)).round
    end
    @total 
  end

>>>>>>> c7f8c338482a16ff53a3a841f88c41437b9ebc5f
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
      @score = view_context.score(votes)
      @color = view_context.busyness_color(@score)
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
<<<<<<< HEAD
    @places_and_colors = view_context.places_and_colors
=======
<<<<<<< HEAD
    places = Place.all
    @places_and_colors = []
    places.each do |place| #refresh each place's scores
      #place.score = score(votes_within(place.votes, 60))
      place.score = score(place.votes)
      @places_and_colors << [place, busyness_color(place.score)]
    end
=======
    @places_and_colors = view_context.places_and_colors
>>>>>>> ed69f651dad80877c0c87afa5257b0381c1ec410
>>>>>>> c7f8c338482a16ff53a3a841f88c41437b9ebc5f
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

