class AddMetaScriptToCreators < ActiveRecord::Migration[7.1]
  def change
    add_column :creators, :meta_script, :text
  end
end
