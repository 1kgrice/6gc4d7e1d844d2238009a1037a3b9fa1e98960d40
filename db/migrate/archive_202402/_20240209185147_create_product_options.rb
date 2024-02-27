class CreateProductOptions < ActiveRecord::Migration[7.1]
  def change
    create_table :product_options do |t|
      t.references :product, null: false, foreign_key: true
      t.string :name
      t.integer :quantity_left
      t.string :description
      t.integer :price_difference_cents
      t.string :recurrence_price_values, type: :json
      t.boolean :is_pwyw

      t.timestamps
    end
  end
end
