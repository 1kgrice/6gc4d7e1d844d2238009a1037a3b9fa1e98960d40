class AddIsWeeklyShowcaseToProducts < ActiveRecord::Migration[7.1]
  def change
    add_column :products, :is_weekly_showcase, :boolean, default: false
  end
end
