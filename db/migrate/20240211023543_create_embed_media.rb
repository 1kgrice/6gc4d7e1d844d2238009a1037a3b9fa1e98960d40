class CreateEmbedMedia < ActiveRecord::Migration[7.1]
  def change
    create_table :embed_media do |t|
      t.integer :mediaable_id
      t.string :mediaable_type
      t.string :url
      t.string :original_url
      t.string :thumbnail
      t.string :external_id
      t.string :media_type
      t.string :filetype
      t.integer :width
      t.integer :height
      t.integer :native_width
      t.integer :native_height

      t.timestamps
    end
  end
end
