class AddSummaryAndPAttributesToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :summary, :string
    add_column :products, :p_attributes, :string, type: :json
  end
end
