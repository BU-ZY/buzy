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

  def new
  	@place = Place.new
  end

  def graphable_votes(votes)
    votes.map {|x| [x.created_at, x.score]}
  end

  def show
    @place = Place.find(params[:id])
    @time_ago = params[:time_ago] ? params[:time_ago].to_i : 60
    unless @place.votes.blank?
      @color = busyness_color(@place.score)
      @graphable  = graphable_votes(recent_votes)
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

