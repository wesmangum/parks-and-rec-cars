class Api::GaragesController < ApplicationController
	rescue_from ActiveRecord::RecordNotFound, :with => :record_not_found
	before_action :authenticate

	def index
		@garages = Garage.all
		render json: @garages
	end

	def show
		if params[:user_id]
			@user = User.find(params[:user_id])
			@garage = @user.garages.find(params[:id])
		else
			@garage = Garage.find(params[:id])
		end

		if @garage
			render json: @garage
		else
			render json: @garage.errors.full_messages, status: 404
		end
	end

	def create
		@garage = Garage.create(garage_params)

		if @garage.save
			render json: @garage, status: 201
		else
			render json: {
				errors: @garage.errors.full_messages
			}, status: 422
		end
	end

	def update
		@garage = Garage.find(params[:id])

		if !@garage.nil? && @garage.user == @current_user
			@garage.update(garage_params)
			if @garage.save
				render json: @garage, status: 204
			else
				render json: {
					errors: @garage.errors.full_messages
				}, status: 422
			end
		else
			render json: {
				error: "Not Authorized",
				message: "not allowed to update? this #{@garage.inspect}"
			}, status: 403
		end
	end

	def destroy
		if params[:user_id]
			@user = User.find(params[:user_id])
			@garage = @user.garages.find(params[:id])
		else
			@garage = Garage.find(params[:id])
		end

		if @garage.user == @current_user
			if @garage.destroy
				render json: @garage, status: 204
			end
		else
			render json: {
				error: "Not Authorized",
				message: "not allowed to update? this #{@garage.inspect}"
			}, status: 403
		end
	end

	private
	def garage_params
		params.require(:garage).permit( :name )
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