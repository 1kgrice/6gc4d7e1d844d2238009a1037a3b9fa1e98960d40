class AddCreatorIdToProducts < ActiveRecord::Migration[7.1]
  def change
    add_reference :products, :creator, null: true, foreign_key: true
  end
end
