require 'rails_helper'
require 'fabrication'

RSpec.describe Api::CarsController, type: :controller do
	before do
		@garage_1 = Fabricate(:garage, name: "Leslie's Garage")
		@garage_2 = Fabricate(:garage, name: "Andy's Garage")
		@car_1 = Fabricate(:car,
			make: "Ford",
			model: "Pinto",
			year: 1971,
			garage: @garage_1
		)
		@car_2 = Fabricate(:car,
			make: "Toyota",
			model: "Prius",
			year: 2015,
			garage: @garage_2
		)
	end

	it "should return all the cars" do
		get :index

		expect(response.body).to include('Ford')
		expect(response.body).to include('Toyota')
	end

	it "should return the single, correct car" do
		get :show, id: @car_1.id

		expect(response.body).to include('Ford')
	end
end
