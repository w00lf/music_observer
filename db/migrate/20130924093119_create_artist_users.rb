class CreateArtistUsers < ActiveRecord::Migration
  def change
    create_table :artist_users do |t|
      t.integer :user_id, null: false
      t.integer :artist_id, null: false
      t.string  :type
      t.boolean :track, default: false
      t.boolean :show, default: false
      t.integer :listeners, default: 0

      t.timestamps
    end
  end
end