class AddStatusToHouse < ActiveRecord::Migration[5.1]
  def change
    add_column :houses, :status, :integer, default: 0
  end
end
