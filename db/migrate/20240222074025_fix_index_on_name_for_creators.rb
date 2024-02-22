class FixIndexOnNameForCreators < ActiveRecord::Migration[7.1]
  def up
    remove_index :products, name: :index_creators_on_name_trgm # past mistake
    safety_assured { 
      execute <<-SQL
        CREATE INDEX index_creators_on_name_trgm ON creators USING gin (name gin_trgm_ops);
      SQL
    }
  end

  def down
    remove_index :creators, name: :index_creators_on_name_trgm
  end
end
