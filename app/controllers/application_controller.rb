class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  def delete_old_votes
    Vote.where("created_at <= ?", Time.now - 1.hour).each{|vote| vote.destroy}
  end

end
