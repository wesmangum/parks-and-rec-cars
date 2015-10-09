require 'rails_helper'
require 'fabrication'

RSpec.describe Api::CarsController, type: :controller do
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
		@request.env["HTTP_AUTHORIZATION"] = "Token token=#{user_1.authentication_token}"
	end

	describe "Happy Path" do
	  it "should return all the cars" do
	  	get :index

	  	expect(response.body).to include('Ford')
	  	expect(response.body).to include('Toyota')
	  end

	  it "should return the single, correct car" do
	  	get :show, id: car_1.id

	  	expect(response.body).to include('Ford')
	  end

	  it "should create a new car and return it" do
	  	post :create, :car => {
	  		:make => "Nissan",
	  		:model => "Sentra",
	  		:year => 2008
	  	}

	  	expect(response.status).to equal(201)
	  	expect(response.body).to include('Nissan')
	  	expect(response.body).to include('null')
	  end

	  it "should update a car and save it" do
	  	put :update, {
	  		:car => {
	  			:make => "Nissan",
	  			:model => "Sentra",
	  			:year => 2008
	  		},
	  		:id => car_1
	  	}

	  	expect(response.status).to equal(204)

	  	get :show, id: car_1.id

	  	expect(response.body).to include('Nissan')
	  end

	  it 'should delete a car from the database' do
	  	delete :destroy, id: car_1.id

	  	expect(response.status).to eq(204)
	  	expect(Car.all.count).to eq(1)
	  end
	end

	describe "Sad Path" do
	  it "should try to create a car and return an error when make is not filled" do
	  	post :create, :car => {
	  		:make => "",
	  		:model => "Sentra",
	  		:year => 2008
	  	}

	  	expect(response.status).to equal(422)
	  	expect(response.body).to include("Make can't be blank")
	  	expect(Car.where( :model => "Sentra")).to_not exist
	  end

	  it "should try to update a car and return an error when make is not filled" do
	  	put :update, {
	  		:car => {
	  			:make => "",
	  			:model => "Ion",
	  			:year => 2008
	  		},
	  		:id => car_1
	  	}

	  	expect(response.status).to equal(422)
	  	expect(response.body).to include("Make can't be blank")
	  	expect(Car.where( :model => "Ion")).to_not exist
	  end

	  it "should try to update a car and return an error when auth token is invalid" do
	  	put :update, {
	  		:car => {
	  			:make => "Nissan",
	  			:model => "Sentra",
	  			:year => 2008
	  		},
	  		:id => car_2
	  	}

	  	expect(response.status).to equal(403)
	  	expect(response.body).to include("not allowed to update?")
	  end
	end
end
