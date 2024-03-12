class AddCheckedAtToCreators < ActiveRecord::Migration[7.1]
  def change
    add_column :creators, :checked_at, :timestamp
  end
end
