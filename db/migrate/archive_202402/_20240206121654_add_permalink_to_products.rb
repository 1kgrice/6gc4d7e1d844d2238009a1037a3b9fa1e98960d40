class AddPermalinkToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :permalink, :string, limit: 255
  end
end
