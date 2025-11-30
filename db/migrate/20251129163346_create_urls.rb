class CreateUrls < ActiveRecord::Migration[8.1]
  def change
    create_table :urls do |t|
      t.text :original_url, null: false
      t.string :code, null: false
      t.integer :access_count, default: 0

      t.timestamps
    end

    add_index :urls, :code, unique: true
    add_index :urls, :original_url
  end
end
