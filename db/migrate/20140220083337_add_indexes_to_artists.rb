class AddIndexesToArtists < ActiveRecord::Migration
  def change
    add_index :artists, [:name, :created_at]
  end
end
