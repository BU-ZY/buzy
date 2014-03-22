class VotesController < ApplicationController
  
  def new
  	@vote = Vote.new
  end

  def show
  	@vote = Vote.find(params[:id])
  end


  def create
    @vote = Vote.new(vote_params)
    if @vote.save
      redirect_to @vote
    else
      render 'new'
    end
  end

  private

    def vote_params
    params.require(:vote).permit(:score,:place_id)

    end

end
