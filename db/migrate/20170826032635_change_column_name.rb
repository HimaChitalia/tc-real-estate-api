class ChangeColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :locations, :langitude, :latitude
  end
end
