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
		@car = Car.create(car_params)

		if @car.save
			render json: @car
		else
			render json: {
				errors: @car.errors.full_messages
			}, status: 422
		end
	end

	def update
		@car = Car.find_by_id(params[:id])
		@car.update(car_params)
		if @car.save
			render json: @car, status: 204
		else
			render json: {
				errors: @car.errors.full_messages
			}, status: 422
		end
	end

	private
	def car_params
		params.require(:car).permit( :make, :model, :year, :garage_id)
	end

end