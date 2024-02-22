class AddMainCoverIdToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :main_cover_id, :string
  end
end
