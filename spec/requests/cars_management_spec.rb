require 'rails_helper'

RSpec.describe "Cars Management", type: :request do
	let!(:garage_1) { Fabricate(:garage, name: "Leslie's Garage") }
	let!(:garage_2) { Fabricate(:garage, name: "Andy's Garage") }
	let!(:car_1) { Fabricate(:car,
			make: "Ford",
			model: "Pinto",
			year: 1971,
			garage: garage_1
		) }
	let!(:car_2) { Fabricate(:car,
			make: "Toyota",
			model: "Prius",
			year: 2015,
			garage: garage_2
		) }

	describe "cars in garages" do
		describe "Happy Path" do
		  it "returns the all the cars in the garage" do
		    get api_garage_cars_path( garage_1 )

		    expect(response.body).to include('Ford')
		  end

		  it "returns a specific car in the garage" do
		    get api_garage_car_path( garage_1, car_1 )

		    expect(response.body).to include('Ford')
		  end

		  it "creates a car associated with a specific garage" do
		  	post api_garage_cars_path( garage_1, :car => {
		  		:make => "Nissan",
		  		:model => "Sentra",
		  		:year => 2008
		  	})

		  	expect(response.status).to equal(201)
		  	expect(response.body).to include('Nissan')
		  	expect(response.body).to include(garage_1.id.to_s)
		  	expect(garage_1.cars.count).to eq(2)
		  end

		  it "updates a car associated with a specific garage" do
		  	put api_garage_car_path( garage_1, :car => {
		  		:make => "Nissan",
		  		:model => "Sentra",
		  		:year => 2008
		  	},
		  	id: car_1.id )

		  	expect(response.status).to equal(204)
		  end

		  it 'deletes the car from the database' do
		  	delete api_garage_car_path( garage_1, car_1 )

		  	expect(response.status).to eq(204)
		  	expect(Car.all.count).to eq(1)
		  	expect(garage_1.cars.count).to eq(0)
		  end
		end

		describe "Sad Path" do
		  it "should try and get a car from a garage and error out" do
		  	get api_garage_car_path( garage_1, car_2 )

		  	expect(response.status).to equal(404)
		  	expect(response.body).to include("Couldn't find Car with 'id'=#{car_2.id}")
		  end

		  it "should try and create a car for a specific garage and error out" do
		  	post api_garage_cars_path( garage_1, :car => {
		  		:make => "",
		  		:model => "Sentra",
		  		:year => 2008
		  	})

		  	expect(response.status).to equal(422)
		  	expect(response.body).to include("Make can't be blank")
		  	expect(garage_1.cars.count).to eq(1)
		  end

		  it "should try and delete a car from a different garage and error out" do
		  	delete api_garage_car_path( garage_1, car_2 )

		  	expect(response.status).to eq(404)
		  	expect(response.body).to include("Couldn't find Car with 'id'=#{car_2.id}")
		  end
		end
	end
end
