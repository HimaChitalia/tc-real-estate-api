class ChangeDataTypeForLatitude < ActiveRecord::Migration[5.1]
  def change
    change_column :houses, :latitude, 'float USING CAST(latitude AS float)'
  end
end
