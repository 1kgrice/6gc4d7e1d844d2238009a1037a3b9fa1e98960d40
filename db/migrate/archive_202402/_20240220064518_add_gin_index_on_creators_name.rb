class AddGinIndexOnCreatorsName < ActiveRecord::Migration[7.1]
  def up
    safety_assured { 
      execute <<-SQL
        CREATE INDEX index_creators_on_name_trgm ON products USING gin (name gin_trgm_ops);
      SQL
    }
  end

  def down
    remove_index :creators, name: :index_creators_on_name_trgm
  end
end
