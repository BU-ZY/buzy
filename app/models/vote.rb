class Vote < ActiveRecord::Base
	belongs_to :place
	belongs_to :user
	validates :score, presence: true, numericality: { only_integer: true, less_than: 11}
end
