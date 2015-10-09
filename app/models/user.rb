class User < ActiveRecord::Base
	validates :email, presence: true
	before_create :set_auth_token

	private
	def set_auth_token
		return if authentication_token.present?
		self.authentication_token = generate_auth_token
	end

	def generate_auth_token
		SecureRandom.urlsafe_base64
	end
end
