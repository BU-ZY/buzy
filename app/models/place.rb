class Place < ActiveRecord::Base
	has_many :votes
	validates :name, presence: true, length: { maximum: 50 }
	validates :location, presence: true
	default_scope order('lower(name)')
end
