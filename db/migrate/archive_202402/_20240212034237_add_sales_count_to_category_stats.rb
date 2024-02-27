class AddSalesCountToCategoryStats < ActiveRecord::Migration[7.1]
  def change
    add_column :category_stats, :sales_count, :integer
  end
end
