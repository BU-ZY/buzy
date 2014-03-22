class Place < ActiveRecord::Base
	has_many :votes
	validates :name, presence: true, length: { maximum: 50 }
	#geocoded_by :address
	#after_validation :geocode
end
