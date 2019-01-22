class CreateSkrwUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :skrw_uploads do |t|
      t.references :uploadable, polymorphic: true
      t.json :file_data
      t.string :file_mime_type
      t.boolean :promoted, default: false

      t.timestamps
    end
  end
end
