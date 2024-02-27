class CreateProductRecurrences < ActiveRecord::Migration[7.1]
  def change
    create_table :product_recurrences do |t|
      t.references :product, null: false, foreign_key: true
      t.string :recurrence
      t.integer :price_cents, default: 0

      t.timestamps
    end
  end
end
