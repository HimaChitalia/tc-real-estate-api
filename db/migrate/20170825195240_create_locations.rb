class CreateLocations < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
      t.string :address
      t.string :city
      t.string :state
      t.string :zipcode
      t.float :langitude
      t.float :longitude

      t.timestamps
    end
  end
end
