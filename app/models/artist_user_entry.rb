class ArtistUserEntry < ActiveRecord::Base
  attr_accessible :artist, :track, :user
  belongs_to :user
  belongs_to :artist

  validates :artist, :user, presence: true
end
