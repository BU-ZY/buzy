require 'open-uri'

class Place < ActiveRecord::Base
	has_many :votes
	validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
	validates :location, presence: true
	default_scope order('lower(name)')

	include ApplicationHelper

	def score(which_votes = nil) # default returns the weighted score for all recent votes
		votes = which_votes ? which_votes : recent_votes.where(place_id: id)
		weighted_score(votes)
	end

	def self.search(query)
    # where(:title, query) -> This would return an exact match of the query
    # where("name like ?", "%#{query}%") -> case sensitive on PostgreSQL!
    where("LOWER(name) LIKE ?", "%#{query.downcase}%")
  end

	def self.cast_vote_from_ingalls_page # method to be run by cron
		begin
			page = Nokogiri::HTML(open("http://www.bu.edu/eng/current-students/ingalls/status/output.html").read)
			data = page.css("strong")
			score = data[0].text.to_i
			score = 100 if score > 100
			ingalls_id = self.find_by(name:'Ingalls').id
			5.times do # cast this vote 5 times
				v = Vote.create(place_id: ingalls_id, score: score)
				raise "Couldn't save vote!" unless v.save
			end
			puts "#{Time.now}: Ingalls scrape successful!"
		rescue => e # catch errors
			puts "#{Time.now}: Ingalls score scraper error: #{e}"
		end
	end
end
