class Garage < ActiveRecord::Base
	validates :name, presence: true
	has_many :cars
end
