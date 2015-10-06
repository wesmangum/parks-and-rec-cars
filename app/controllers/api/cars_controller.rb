class Api::CarsController < ApplicationController

	def index
		if params[:garage_id]
			@cars = Car.find_by(garage_id: params[:garage_id])
		else
			@cars = Car.all
		end
		render json: @cars
	end

	def show
		if params[:garage_id]
			@car = Car.find_by(
				garage_id: params[:garage_id],
				id: params[:id]
			)
		else
			@car = Car.find_by_id(params[:id])
		end
		render json: @car
	end

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