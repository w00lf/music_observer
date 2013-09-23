class AddUserIdToArtists < ActiveRecord::Migration
  def change
    add_column :artists, :user_id, :integer
  end
  Artist.update_all(:user_id => User.last.id) unless User.last.nil?
end
