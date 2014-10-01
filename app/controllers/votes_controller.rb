class VotesController < ApplicationController
  # ***DISABLING SIGN IN FOR DEV***
  #before_action :signed_in_user, only: [:new,:create]
  
  def new
  	@vote = Vote.new
    if params[:id]
      @place = params[:id]
    end
    @place
  end

  def show
  	@vote = Vote.find(params[:id])
  end

  def create
    refer_page = URI(request.referer).path
    @vote = Vote.new(vote_params)
    if @vote.save
      redirect_to refer_page # this takes us back to whatever page the form was submitted on
      # redirect_to place_path(@vote.place)
    else
      render 'new'
    end
  end

  def ingallsVote
    PAGE_URL = "http://www.bu.edu/eng/current-students/ingalls/status/output.html"
    page = Nokogiri::HTML(open(PAGE_URL))
    data = page.css("strong")
    people = data[0].text.to_i

    if people > 100
      @score =  100
    else
      @score =  people
    end

    Vote.create(score: @score,place_id: 1)
    puts "ingalls test"
  end

  private

    def vote_params
      params.require(:vote).permit(:score,[:place_id])
    end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
end
