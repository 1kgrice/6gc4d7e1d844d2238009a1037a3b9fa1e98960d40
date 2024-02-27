class AddCommonCompositeIndexesToProducts < ActiveRecord::Migration[7.1]
  disable_ddl_transaction!
  def change
     #simulater staff picks
    add_index :products, [:rating, :rating_counts_total, :created_at], algorithm: :concurrently
    #best selling
    add_index :products, [:sales_count, :rating, :created_at], algorithm: :concurrently 
    #hot_and_new
    add_index :products, [:rating_counts_total, :created_at], algorithm: :concurrently 
    #default
    add_index :products, [:updated_at, :created_at], algorithm: :concurrently 
  end
end
