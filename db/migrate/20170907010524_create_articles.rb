class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.string :key
      t.string :title
      t.string :url
      t.integer :likes, default: 0

      t.timestamps
    end
  end
end
