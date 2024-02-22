class RemoveNotNullProductConstraintFromProductReferences < ActiveRecord::Migration[7.1]
  def up
    change_column_null :product_references, :product_id, true
  end

  def down
    change_column_null :product_references, :product_id, false
  end
end
