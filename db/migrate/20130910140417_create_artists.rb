class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.integer :api_id
      t.boolean :track, :default => false
      t.string :mbid

      t.timestamps
    end
    add_attachment :artists, :photo
  end
end