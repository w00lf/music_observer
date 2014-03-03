class AddConstraintToArtistsTags < ActiveRecord::Migration
  def change
    add_index :artists_tags, [:artist_id, :tag_id], :unique => true
  end
end
