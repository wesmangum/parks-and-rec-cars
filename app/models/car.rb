class Car < ActiveRecord::Base
	validates :make, presence: true
	belongs_to :garage
end
