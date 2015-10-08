require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do

	describe "Happy Path" do
		it 'should create a new User' do
			post :create, :api_user => {
				email: "leslie.knope@pawnee.gov",
				password: "pancakes"
			}

			expect(response.status).to eq(201)
			expect(response.body).to include("leslie.knope@pawnee.gov")
			expect(response.body).to_not include("password")
			expect(User.all.count).to eq(1)
		end
	end

	describe "Sad Path" do
		it 'should try and create a new user with no password and error out' do
			post :create, :api_user => {
				email: "",
				password: "pancakes"
			}

			expect(response.status).to eq(422)
			expect(response.body).to include("Email can't be blank")
			expect(User.all.count).to eq(0)
		end
	end
end
