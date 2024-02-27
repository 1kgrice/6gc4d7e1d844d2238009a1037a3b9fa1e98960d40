class CreateGProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :g_products do |t|
      t.string :name
      t.text :description
      t.string :url
      t.integer :review_count
      t.decimal :rating
      t.decimal :price
      t.string :g_user_name
      t.string :g_user_url
      
      t.timestamps
    end
  end
end
