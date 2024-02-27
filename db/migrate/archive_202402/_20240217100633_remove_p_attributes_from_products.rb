class RemovePAttributesFromProducts < ActiveRecord::Migration[7.1]
  def change
    safety_assured { remove_column :products, :p_attributes }
  end
end
