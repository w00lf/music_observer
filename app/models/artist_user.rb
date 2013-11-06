class ArtistUser < ActiveRecord::Base
  attr_accessible :artist, :user
  belongs_to :user
  belongs_to :artist

  belongs_to :link, polymorphic: true

  validates :artist, :user, presence: true
end
