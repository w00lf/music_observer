class CreateArtistUserEntries < ActiveRecord::Migration
  def change
    create_table :artist_user_entries do |t|
      t.integer :user_id
      t.integer :artist_id
      t.boolean :track, null: false, default: false

      t.timestamps
    end
  end
end
