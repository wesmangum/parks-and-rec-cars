class Api::UsersController < ApplicationController

	def create
		@user = User.create(user_params)

		if @user.save
			render json: {
				id: @user.id,
				email: @user.email,
				authentication_token: @user.authentication_token
			}, status: 201
		else
			render json: {
				errors: @user.errors.full_messages
			}, status: 422
		end
	end

	def login
		@user = User.find_by(params[:email])

		if @user.password === params[:api_user][:password] &&
			@user.email === params[:api_user][:email]
			render json: {
				id: @user.id,
				email: @user.email,
				authentication_token: @user.authentication_token
			}, status: 201
		else
			puts @user.errors.full_messages
			render json: {
				errors: ["Incorrect Email/Password"]
			}, status: 422
		end
	end

	private
	def user_params
		params.require(:api_user).permit( :email, :password )
	end

end
