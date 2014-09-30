class Place < ActiveRecord::Base
	has_many :votes
	validates :name, presence: true, length: { maximum: 50 }
	validates :location, presence: true
	default_scope order('lower(name)')

	include ApplicationHelper

	def score(which_votes = nil) # default returns the weighted score for all recent votes
		votes = which_votes ? which_votes : recent_votes.where(place_id: id)
		weighted_score(votes)
	end
end
