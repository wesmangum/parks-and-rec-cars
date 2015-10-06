class AddGarageToCar < ActiveRecord::Migration
  def change
    add_reference :cars, :garage, index: true, foreign_key: true
  end
end
