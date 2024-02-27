class CreateCreators < ActiveRecord::Migration[7.1]
  def change
    create_table :creators do |t|
      t.string :name
      t.string :username
      t.text :bio
      t.string :logo

      t.timestamps
    end

    add_index :creators, :username, unique: true
  end
end
