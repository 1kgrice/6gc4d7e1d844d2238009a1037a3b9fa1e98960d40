class AddUniqueIndexOnProductRecurrences < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
    add_index :product_recurrences, [:product_id, :recurrence], unique: true, where: "recurrence IS NOT NULL AND recurrence <> '' AND product_id IS NOT NULL", algorithm: :concurrently
  end
end
