class CreateGarages < ActiveRecord::Migration
  def change
    create_table :garages do |t|

      t.timestamps null: false
    end
  end
end
