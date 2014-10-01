INGALLS_URL = "http://www.bu.edu/eng/current-students/ingalls/status/output.html"

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

	def cast_vote_from_ingalls_page # method to be run by cron
		begin
			page = Nokogiri::HTML(open(PAGE_URL))
			data = page.css("strong")
			score = data[0].text.to_i
			score = 100 if score > 100
			ingalls_id = Place.find_by(name: 'Ingalls').id
			5.times do # cast this vote 5 times
				Vote.create(place_id: ingalls_id, score: score)
			end
			puts "Ingalls scrape successful!"
		rescue: e # catch errors
			puts "Ingalls score scraper error: #{e}"
		end
	end
end
