require 'rails_helper'

RSpec.describe Api::CarsController, type: :controller do
	before do
		@car_1 = Fabricate(:car)
	end

	it "should return all the cars" do
		get api_cars

		puts response_body
	end
end
