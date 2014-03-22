class PlacesController < ApplicationController

  def busyness_color(score)
    case score
      when 0..3
        @color = '#66CC00'
      when 34..6
        @color = '#FF9933'
      else
        @color = '#FF0000'
    end
    @color
  end

  def avg_score(place)
    @total = 0
    place.votes.each do |vote|
      @total += vote.score
    end
    @average = @total/place.votes.length
  end

  def new
  	@place = Place.new
  end

  def show
  	@place = Place.find(params[:id])

    unless @place.votes.blank? #calculate average
      @average = avg_score(@place)
      @color = busyness_color(@average)
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
  end

  def place_exists_with_name(name) #render an error page if the user tried to create a place that already exists
    @name = name
  end

  private

    def place_params
      params.require(:place).permit(:name)
    end

end

