class AddConstraintToArtistUsers < ActiveRecord::Migration
  def change
    add_index :artist_users, [:user_id, :artist_id, :type], :unique => true
  end
end
