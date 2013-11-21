class AddDescriptionAndApiLinkToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :description, :text
    add_column :artists, :api_link, :string
  end
end
