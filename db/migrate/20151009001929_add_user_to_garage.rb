class AddUserToGarage < ActiveRecord::Migration
  def change
  	add_reference :garages, :user, index: true, foreign_key: true
  end
end
