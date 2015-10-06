class Car < ActiveRecord::Base
	belongs_to :garage

	def create
		@car = Car.new

		@car.make = params[:make]
		@car.model = params[:model]
		@car.year = params[:year]
		@car.garage_id = params[:garage_id]

		@car.save
		redirect_to @car
	end
end
