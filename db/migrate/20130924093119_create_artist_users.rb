class CreateArtistUsers < ActiveRecord::Migration
  def change
    create_table :artist_users do |t|
      t.integer :user_id
      t.integer :artist_id
      t.integer :link_id
      t.string :link_type

      t.timestamps
    end
  end
end
