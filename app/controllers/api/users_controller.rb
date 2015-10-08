class Api::UsersController < ApplicationController

	def create
		@user = User.create(user_params)

		if @user.save
			render json: {
				id: @user.id,
				email: @user.email
			}, status: 201
		else
			render json: {
				errors: @user.errors.full_messages
			}, status: 422
		end
	end

	private
	def user_params
		params.require(:api_user).permit( :email, :password )
	end
end
