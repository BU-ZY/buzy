class Vote < ActiveRecord::Base
	belongs_to :place
	belongs_to :user
	validates :place_id, presence: true
	validates :score, presence: true, numericality: { only_integer: true, less_than: 101}
end
