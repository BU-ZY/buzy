class PlacesController < ApplicationController
  include SessionsHelper
  include ApplicationHelper
  # ***DISABLING SIGN IN FOR DEV***
  #before_action :signed_in_user, only: [:new]


  # def new
  # 	@place = Place.new
  # end

  # def graphable_votes(votes)
  #   votes.map {|x| [x.created_at, x.score]}
  # end

  # def show
  #   # update_scores(params[:id]) # update the score of just this place
  #   @place = Place.find(params[:id])
  #   @time_ago = params[:time_ago] ? params[:time_ago].to_i : 60 # get the time-ago in minutes from the url, if it exists
  #   votes = votes_within(@time_ago, params[:id])
  #   @graphable  = graphable_votes(votes_within(@time_ago, params[:id]))
  #   @username = "Public"
  #   @score = weighted_score(votes) # don't just use place.score!
  #   @color = busyness_color(@score)
  # end

  # def create
  #   if Place.where(:name => place_params[:name]).blank? #check if a place with that name exists
  #     @place = Place.new(place_params)
  #     if @place.save
  #       redirect_to @place
  #     else
  #       render 'new'
  #     end
  #   else
  #     @name = place_params[:name]
  #     render 'place_exists_with_name'
  #   end
  # end

  def index
    @places = Place.order_by_popularity.all
  end

  private

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
end

