require 'rails_helper'

RSpec.describe "Garages Management", type: :request do
	let!(:user_1) { Fabricate(:user) }
	let!(:user_2) { Fabricate(:user,
			email: "leslie_knope@pawnee.gov",
			password: "pancakes"
		) }
	let!(:auth_headers) {
			{
				"HTTP-AUTHORIZATION" => "Token token=#{user_1.authentication_token}"
			}
		}
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

	describe "garages belonging to users" do
		describe "Happy Path" do
		  it "returns the all the garages belonging to a user" do
		    get api_user_garages_path( user_1 ), nil, @env

		    expect(response.body).to include("Leslie's Garage")
		  end

		  it "returns a specific garage belonging to a user" do
		    get api_user_garage_path( user_1, garage_1 ), nil, @env

		    expect(response.body).to include("Leslie's Garage")
		  end

		  it "creates a garage associated with a specific user" do
		  	post api_user_garages_path( garage_1, :garage => {
		  		:name => "New Garage"
		  	}), nil, @env

		  	expect(response.status).to equal(201)
		  	expect(response.body).to include('New Garage')
		  	expect(response.body).to include(garage_1.id.to_s)
		  	expect(user_1.garages.count).to eq(1)
		  end

		  it "updates a garage associated with a specific user" do
		  	put api_user_garage_path( garage_1, :garage => {
		  		:name => "New Garage"
		  	},
		  	id: car_1.id ), nil, @env

		  	expect(response.status).to equal(204)
		  end

		  it 'deletes the garage from the database' do
		  	delete api_user_garage_path( user_1, garage_1 ), nil, @env

		  	expect(response.status).to eq(204)
		  	expect(Garage.all.count).to eq(1)
		  	expect(user_1.garages.count).to eq(0)
		  end
		end

		describe "Sad Path" do
		  it "should try and get a garage from a user and error out" do
		  	get api_user_garage_path( user_1, garage_2 ), nil, @env

		  	expect(response.status).to equal(404)
		  	expect(response.body).to include("Couldn't find Garage with 'id'=#{garage_2.id}")
		  end

		  it "should try and create a garage for a specific user and error out" do
		  	post api_user_garages_path( user_1, :garage => {
		  		:name => "",
		  	}), nil, @env

		  	expect(response.status).to equal(422)
		  	expect(response.body).to include("Name can't be blank")
		  	expect(garage_1.cars.count).to eq(1)
		  end

		  it "should try and delete a garage from a different user and error out" do
		  	delete api_user_garage_path( user_1, garage_2 ), nil, @env

		  	expect(response.status).to eq(404)
		  	expect(response.body).to include("Couldn't find Garage with 'id'=#{garage_2.id}")
		  end
		end
	end
end
