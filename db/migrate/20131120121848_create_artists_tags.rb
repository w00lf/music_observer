class CreateArtistsTags < ActiveRecord::Migration
  def change
    create_table :artists_tags, :id => false do |t|
      t.belongs_to :tag
      t.belongs_to :artist
    end
  end
end
