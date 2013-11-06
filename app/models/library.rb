class Library < ActiveRecord::Base
  attr_accessible :listened, :show, :track

  has_one :artist_user, as: :link
  has_one :user, through: :artist_user
  has_one :artist, through: :artist_user
end
