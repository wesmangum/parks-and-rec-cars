class Api::CarsController < ApplicationController
	rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
	before_action :authenticate

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
		if params[:garage_id]
			params[:car][:garage_id] = params[:garage_id]
		end

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
		@car = Car.find(params[:id])
		@garage = Garage.find(@car.garage_id)
		@user = User.find(@garage.user_id)

		if !@car.nil? && @user == @current_user
			@car.update(car_params)
			if @car.save
				render json: @car, status: 204
			else
				render json: {
					errors: @car.errors.full_messages
				}, status: 422
			end
		else
			render json: {
				error: "Not Authorized",
				message: "not allowed to update? this #{@car.inspect}"
			}, status: 403
		end
	end

	def destroy
		@car = Car.find(params[:id])

		if @car.garage.user == @current_user
			if @car.destroy
				render json: @car, status: 204
			end
		else
			render json: {
				error: "Not Authorized",
				message: "not allowed to update? this #{@var.inspect}"
			}, status: 403
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

	def authenticate
      authenticate_or_request_with_http_token do |token, options|
        	@current_user = User.find_by(authentication_token: token)
      end
    end

end