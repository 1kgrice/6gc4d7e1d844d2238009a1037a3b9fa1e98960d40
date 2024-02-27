class AddMetaUrlToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :meta_url, :string
  end
end
