class Api::GaragesController < ApplicationController

	def index
		@garages = Garage.all
		render json: @garages
	end

	def show
		@garage = Garage.find_by_id(params[:id])
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
		@garage = Garage.find_by_id(params[:id])
		@garage.update(garage_params)
		if @garage.save
			render json: @garage, status: 204
		else
			render json: {
				errors: @garage.errors.full_messages
			}, status: 422
		end
	end

	private
	def garage_params
		params.require(:garage).permit( :name )
	end

end