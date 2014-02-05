class Favorite < ArtistUser
  attr_accessible :artist_id, :user_id, :track, :show, :listeners
  belongs_to :user
  belongs_to :artist
  after_create :check_duplicates

  private 
  def check_duplicates
    Recommendation.where(artist_id: artist_id, user_id: user).delete_all
  end
end
