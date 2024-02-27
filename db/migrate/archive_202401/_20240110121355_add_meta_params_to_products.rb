class AddMetaParamsToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :meta_params, :string
  end
end
