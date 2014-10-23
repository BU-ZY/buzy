class Vote < ActiveRecord::Base
	belongs_to :place
	belongs_to :user
	validates :place_id, presence: true
	validates :score, presence: true, numericality: { only_integer: true, less_than: 101}
  validates :score, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }
  default_scope order('created_at DESC')

	def within?(x) # boolean t/f if the vote was cast in the last x minutes
		raise "Expected an integer" unless x.is_a?(Integer)
		self.created_at >= Time.now - x.minutes
	end
end
