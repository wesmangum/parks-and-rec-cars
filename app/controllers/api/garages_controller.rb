class Api::GaragesController < ApplicationController

	def index
		@garages = Garage.all
		render json: @garages
	end

	def show
		@garage = Garage.find_by_id(params[:id])
		render json: @garage
	end

end