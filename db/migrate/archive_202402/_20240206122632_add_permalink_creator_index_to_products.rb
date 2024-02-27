class AddPermalinkCreatorIndexToProducts < ActiveRecord::Migration[7.1]
  def change
    add_index :products, [:creator_id, :permalink], unique: true, where: "(creator_id IS NOT NULL AND permalink IS NOT NULL)"
  end
end
