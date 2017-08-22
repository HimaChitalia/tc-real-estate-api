class CreateHouses < ActiveRecord::Migration[5.1]
  def change
    create_table :houses do |t|
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.string :category
      t.string :latitude
      t.string :longitude
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
