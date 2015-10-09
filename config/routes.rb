Rails.application.routes.draw do
	namespace :api do
		resources :cars
		resources :garages do
			resources :cars
		end
		resources :users do
			resources :garages
		end
		post "/users/login" => "users#login"
	end
end
