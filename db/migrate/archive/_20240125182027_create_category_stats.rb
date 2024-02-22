class CreateCategoryStats < ActiveRecord::Migration[7.1]
  def change
    create_table :category_stats do |t|
      t.references :category, null: false, foreign_key: true
      t.integer :creator_count, default: 0
      t.integer :product_count, default: 0

      t.timestamps
    end
  end
end
