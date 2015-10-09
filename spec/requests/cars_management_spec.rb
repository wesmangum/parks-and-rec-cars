require 'rails_helper'

RSpec.describe "Cars Management", type: :request do
	let!(:user_1) { Fabricate(:user) }
	let!(:user_2) { Fabricate(:user,
			email: "leslie.knope@pawnee.gov",
			password: "pancakes"
		) }
	let!(:garage_1) { Fabricate(:garage,
			name: "Leslie's Garage",
			user: user_1
		) }
	let!(:garage_2) { Fabricate(:garage,
			name: "Andy's Garage",
			user: user_2
		) }
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
	before(:each) do
		@env = Hash.new
		@env["CONTENT_TYPE"] = "application/json"
		@env["ACCEPT"] = "application/json"
		@env["HTTP_AUTHORIZATION"] = "Token token=#{user_1.authentication_token}"
	end

	describe "cars in garages" do
		describe "Happy Path" do
		  it "returns the all the cars in the garage" do
		    get api_garage_cars_path( garage_1 ), nil, @env

		    expect(response.body).to include('Ford')
		  end

		  it "returns a specific car in the garage" do
		    get api_garage_car_path( garage_1, car_1 ), nil, @env

		    expect(response.body).to include('Ford')
		  end

		  it "creates a car associated with a specific garage" do
		  	post api_garage_cars_path( garage_1, :car => {
		  		:make => "Nissan",
		  		:model => "Sentra",
		  		:year => 2008
		  	}), nil, @env

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
		  	id: car_1.id ), nil, @env

		  	expect(response.status).to equal(204)
		  	@car = Car.find(car_1.id)
		  	expect(@car.make).to eq("Nissan")
		  end

		  it 'deletes the car from the database' do
		  	delete api_garage_car_path( garage_1, car_1 ), nil, @env

		  	expect(response.status).to eq(204)
		  	expect(Car.all.count).to eq(1)
		  	expect(garage_1.cars.count).to eq(0)
		  end
		end

		describe "Sad Path" do
		  it "should try and get a car from a garage and error out" do
		  	get api_garage_car_path( garage_1, car_2 ), nil, @env

		  	expect(response.status).to equal(404)
		  	expect(response.body).to include("Couldn't find Car with 'id'=#{car_2.id}")
		  end

		  it "should try and create a car for a specific garage and error out" do
		  	post api_garage_cars_path( garage_1, :car => {
		  		:make => "",
		  		:model => "Sentra",
		  		:year => 2008
		  	}), nil, @env

		  	expect(response.status).to equal(422)
		  	expect(response.body).to include("Make can't be blank")
		  	expect(garage_1.cars.count).to eq(1)
		  end

		  it "should try and update a car for a specific garage and error out" do
		  	put api_garage_car_path( garage_1, :car => {
		  		:make => "",
		  		:model => "Sentra",
		  		:year => 2008
		  	},
		  	id: car_1.id ), nil, @env

		  	expect(response.status).to equal(422)
		  	expect(response.body).to include("Make can't be blank")
		  	expect(garage_1.cars.count).to eq(1)
		  end

		  it "should try to update a car for a specific garage and return an error when auth token is invalid" do
		  	put api_garage_car_path( garage_1, :car => {
		  		:make => "",
		  		:model => "Sentra",
		  		:year => 2008
		  	},
		  	id: car_2.id ), nil, @env

		  	expect(response.status).to equal(403)
		  	expect(response.body).to include("not allowed to update?")

		  	@car = Car.find(car_2.id)

		  	expect(@car.make).to eq("Toyota")
		  end

		  it "should try and delete a car from a different garage and error out" do
		  	delete api_garage_car_path( garage_1, car_2 ), nil, @env

		  	expect(response.status).to equal(403)
		  	expect(response.body).to include("not allowed to update?")

		  	@car = Car.find(car_2.id)

		  	expect(@car.make).to eq("Toyota")
		  end
		end
	end
end
