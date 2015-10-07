class Api::CarsController < ApplicationController
	rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found

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
			@garage = Garage.find(params[:garage_id])
			@car = @garage.cars.find(params[:id])
		else
			@car = Car.find(params[:id])
		end

		if @car
			render json: @car
		else
			render json: @car.errors.full_messages, status: 404
		end
	end

	def create
		@car = Car.create(car_params)

		if @car.save
			render json: @car, status: 201
		else
			render json: {
				errors: @car.errors.full_messages
			}, status: 422
		end
	end

	def update
		if params[:garage_id]
			@garage = Garage.find(params[:garage_id])
			@car = @garage.cars.find(params[:id])
		else
			@car = Car.find(params[:id])
		end

		@car.update(car_params)

		if @car.save
			render json: @car, status: 204
		else
			render json: {
				errors: @car.errors.full_messages
			}, status: 422
		end
	end

	def destroy
		if params[:garage_id]
			@garage = Garage.find(params[:garage_id])
			@car = @garage.cars.find(params[:id])
		else
			@car = Car.find(params[:id])
		end

		if @car.destroy
			render json: @car, status: 204
		end
	end

	private
	def car_params
		params.require(:car).permit( :make, :model, :year, :garage_id)
	end

	def record_not_found(error)
		render json: {
			error: "Record Not Found",
			message: error.message
		}, status: 404
	end

end