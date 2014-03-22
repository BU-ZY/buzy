class PlacesController < ApplicationController

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

  def score(place)
    now = Time.new
   
    total_time_ago = 0 
    place.votes.each do |vote| #total times ago
      total_time_ago += now - vote.created_at
    end
    
    @total = 0
    place.votes.each do |vote| #calc weighted average
      time_ago = (now-vote.created_at)
      @total += (vote.score*(time_ago/total_time_ago)).round
    end
    @total 
  end

  def new
  	@place = Place.new
  end

  def show
  	@place = Place.find(params[:id])
    unless @place.votes.blank?
      @score = score(@place)
      @color = busyness_color(@score)
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
      place_exists_with_name place_params[:name]
      render 'place_exists_with_name'
    end

  end

  def index
    @places = Place.all
    @hash = Gmaps4rails.build_markers(@users) do |user, marker|
    marker.lat user.latitude
    marker.lng user.longitude
end
  end

  def place_exists_with_name(name) #render an error page if the user tried to create a place that already exists
    @name = name
  end

  private

    def place_params
      params.require(:place).permit(:name)
    end

end

