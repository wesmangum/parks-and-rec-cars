class Api::CarsController < ApplicationController

	def index
		@cars = Car.all
		render json: @cars
	end

	def show
		@car = Car.find_by_id(params[:id])
		render json: @car
	end

end