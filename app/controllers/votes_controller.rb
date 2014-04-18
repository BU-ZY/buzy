class VotesController < ApplicationController
  # ***DISABLING SIGN IN FOR DEV***
  #before_action :signed_in_user, only: [:new,:create]
  
  def new
  	@vote = Vote.new
    if params[:id]
      @place = params[:id]
    end
  end

  def show
  	@vote = Vote.find(params[:id])
  end

  def create
    @vote = Vote.new(vote_params)
    if @vote.save
      redirect_to place_path(@vote.place)
    else
      render 'new'
    end
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
