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

	def prediction(opts={})
		votes = votes_closest_to_now(opts)
		if votes.empty?
			nil
		else
			(votes.inject(0){|sum, vote| sum + vote.score}.to_f/votes.size).round # the average 
		end
	end

	def self.search(query)
    # where(:title, query) -> This would return an exact match of the query
    # where("name like ?", "%#{query}%") -> case sensitive on PostgreSQL!
    where("LOWER(name) LIKE ?", "%#{query.downcase}%")
	end

	def self.find_by_tag(tag_name) # finds any place where the first item in it's tag array is the given tag name
		where("'#{tag_name.downcase}' = tags[1]")
	end

	def votes_closest_to_now(opts={}) # returns past votes closest to the current hour
		num_records = opts[:num] ? opts[:num] : 25 # number of records to return
		hour_of_day = opts[:hour] ? opts[:hour] : DateTime.now.hour
		margin = opts[:margin] ? opts[:margin] : 2 # the allowed difference in hours between 'hour' and the time the vote was cast
		votes.where("abs(extract(hour from created_at) - #{hour_of_day}) <= #{margin}").order(created_at: :asc).take(num_records)
	end

	def self.allowed_tags
		["study","dining","entertainment","fitness"]
	end

	# tagging - the first tag is the primary tag

	def add_tag(new_tag)
		update_attributes(tags: self.tags + [new_tag]) if Place.allowed_tags.include?(new_tag)
	end

	def add_tags(tag_array)
		tag_array.each do |tag|
			update_attributes(tags: self.tags + [new_tag]) if Place.allowed_tags.include?(new_tag)
		end
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
