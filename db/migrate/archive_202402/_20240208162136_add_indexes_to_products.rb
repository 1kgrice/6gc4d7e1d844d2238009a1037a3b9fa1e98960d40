class AddIndexesToProducts < ActiveRecord::Migration[7.1]
  def change
      # Since you're searching by name using LIKE, a full-text search index might be more appropriate depending on your DBMS.
      # For PostgreSQL, consider using pg_trgm extension and GIN index for better performance with LIKE queries.
      # However, for simplicity, here's a basic index addition:
      # add_index :products, :name
  
      # Index for sorting by rating, created_at, and price_cents
      add_index :products, :rating
      add_index :products, :created_at
      add_index :products, :price_cents
  
      # # Index for category_slugs, since you're checking array containment
      # add_index :products, :category_slugs, using: :gin
  
      # Indexes for filtering on published and available status
      add_index :products, :published
      add_index :product_references, :available
    end
end
