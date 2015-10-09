require 'rails_helper'

RSpec.describe Api::GaragesController, type: :controller do
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
		it "should return all the garages" do
			get :index

			expect(response.body).to include("Andy's Garage")
			expect(response.body).to include("Leslie's Garage")
		end

		it "should return the single, correct garage" do
			get :show, id: garage_1.id

			expect(response.body).to include("Leslie's Garage")
		end

		it "should create a new garage and return it" do
			post :create, :garage => {
				:name => "New Garage"
			}

			expect(response.status).to equal(201)
			expect(response.body).to include('New Garage')
		end

		it "should update a garage and save it" do
			put :update, {
				:garage => {
					:name => "Newer Garage"
				},
				:id => garage_1
			}

			expect(response.status).to equal(204)

			@garage = Garage.find(garage_1.id)

			expect(@garage.name).to eq('Newer Garage')
		end

		it 'should delete a garage from the database' do
			delete :destroy, id: garage_1.id

			expect(response.status).to eq(204)
			expect(Garage.all.count).to eq(1)
		end
	end

	describe "Sad Path" do
		it "should try to create a garage and return an error when name is not filled" do
			post :create, :garage => {
				:name => ""
			}

			expect(response.status).to equal(422)
			expect(response.body).to include("Name can't be blank")
			expect(Garage.count).to equal(2)
		end

		it "should try to update a garage and return an error when name is not filled" do
			put :update, {
				:garage => {
					:name => "",
				},
				:id => garage_1
			}

			expect(response.status).to equal(422)
			expect(response.body).to include("Name can't be blank")

			@garage = Garage.find_by_id( garage_2 )
			expect(@garage.name).to eq("Andy's Garage")
		end

		it "should try to update a garage and return an error when auth token is incorrect" do
			put :update, {
				:garage => {
					:name => "New Garage",
				},
				:id => garage_2
			}

			expect(response.status).to equal(403)
			expect(response.body).to include("not allowed to update?")
			expect(response.body).to include("Andy's Garage")

			@garage = Garage.find_by_id( garage_2 )
			expect(@garage.name).to eq("Andy's Garage")
		end

		it "should try to delete a garage and return an error when auth token is incorrect" do
			delete :destroy, id: garage_2.id

			expect(response.status).to equal(403)
			expect(response.body).to include("not allowed to update?")
			expect(response.body).to include("Andy's Garage")

			@garage = Garage.find_by_id( garage_2 )
			expect(@garage.name).to eq("Andy's Garage")
		end
	end
end
