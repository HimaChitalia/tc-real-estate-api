class ChangeDataTypeForLongitude < ActiveRecord::Migration[5.1]
  def change
    change_column :houses, :longitude, 'float USING CAST(longitude AS float)'
  end
end
