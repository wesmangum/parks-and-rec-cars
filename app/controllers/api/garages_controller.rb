class Api::GaragesController < ApplicationController
	before_action :authenticate

	def index
		@garages = Garage.all
		render json: @garages
	end

	def show
		@garage = Garage.find(params[:id])
		render json: @garage
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
		@garage = Garage.find(params[:id])

		if @garage.destroy
			render json: @garage, status: 204
		end
	end

	private
	def garage_params
		params.require(:garage).permit( :name )
	end

	def authenticate
      authenticate_or_request_with_http_token do |token, options|
        	@current_user = User.find_by(authentication_token: token)
      end
    end

end