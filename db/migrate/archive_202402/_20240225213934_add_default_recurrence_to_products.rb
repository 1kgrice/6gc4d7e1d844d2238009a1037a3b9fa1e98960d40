class AddDefaultRecurrenceToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :default_recurrence, :string
  end
end
