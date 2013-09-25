class CreateArtists < ActiveRecord::Migration
  def change
    create_table :artists do |t|
      t.string :name
      t.string :mbid

      t.timestamps
    end
    add_attachment :artists, :photo
  end
end