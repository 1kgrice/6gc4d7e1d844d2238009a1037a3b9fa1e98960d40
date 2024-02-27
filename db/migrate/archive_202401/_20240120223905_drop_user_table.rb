class DropUserTable < ActiveRecord::Migration[7.1]
  drop_table :users , force: :cascade
end
