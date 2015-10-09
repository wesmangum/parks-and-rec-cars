require 'rails_helper'

RSpec.describe Api::UsersController, type: :controller do
	let!(:user_1) { Fabricate(:user) }

	describe "Happy Path" do
		it 'should create a new User' do
			post :create, :api_user => {
				email: "leslie.knope@pawnee.gov",
				password: "pancakes"
			}

			expect(response.status).to eq(201)
			expect(response.body).to include("leslie.knope@pawnee.gov")
			expect(response.body).to include("authentication_token")
			expect(response.body).to_not include("password")
			expect(User.all.count).to eq(2)
		end

		it 'shold log in an existing User' do

			post :login, :api_user => {
				email: "ron.swanson@pawnee.gov",
				password: "anewpassword"
			}

			expect(response.status).to eq(201)
			expect(response.body).to include("ron.swanson@pawnee.gov")
			expect(response.body).to include("authentication_token")
			expect(response.body).to_not include("password")
			expect(User.all.count).to eq(1)
		end
	end

	describe "Sad Path" do
		it 'should try and create a new user with no email and error out' do
			post :create, :api_user => {
				password: "pancakes"
			}

			expect(response.status).to eq(422)
			expect(response.body).to include("Email can't be blank")
			expect(response.body).to_not include("password")
			expect(response.body).to_not include("authentication_token")
			expect(User.all.count).to eq(1)
		end

		it 'should try and login a user with no email and error out' do

			post :login, :api_user => {
				email: "",
				password: "anewpassword"
			}

			expect(response.status).to eq(422)
			expect(response.body).to include("Incorrect Email/Password")
			expect(response.body).to_not include("password")
			expect(response.body).to_not include("authentication_token")
		end
	end
end
