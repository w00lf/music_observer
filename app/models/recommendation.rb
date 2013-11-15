class Recommendation < ArtistUser
  attr_accessible :artist_id, :user_id, :show
  belongs_to :user
  belongs_to :artist

  scope :publick, where(show: true)
end
