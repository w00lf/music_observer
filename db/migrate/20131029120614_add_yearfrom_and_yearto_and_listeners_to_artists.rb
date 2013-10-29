class AddYearfromAndYeartoAndListenersToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :year_from, :datetime
    add_column :artists, :year_to, :datetime
    add_column :artists, :listeners, :integer
  end
end
