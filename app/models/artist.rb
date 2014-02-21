class Artist < ActiveRecord::Base
  extend ApplicationHelper
  attr_accessible :mbid, :name, :track, :listeners, :photo, :year_from, :year_to, :description, :api_link

  validates :name, :mbid, presence: true
  validates :name, :mbid, uniqueness: true

  has_many :concerts
  has_many :favorites, dependent: :destroy
  has_many :recommendations, dependent: :destroy
  # has_many :libraries, :through => :artist_users, :source => :link, :source_type => 'Library'

  has_many :users_favorites,  through: :favorites, source: :user, conditions: { artist_users: { type: "Favorite" } }
  has_many :users_recommendations, through: :recommendations, source: :user, conditions: { artist_users: { type: "Recommendation" } }
  has_and_belongs_to_many :tags
  
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  class << self
    def create_favorite prop, user
      artist = find_or_create(prop)
      Favorite.find_or_create_by_user_id_and_artist_id(user.id, artist.id, track: prop[:track] || false)
      artist
    end

    def create_recommended prop, user
      artist = find_or_create(prop)
      Recommendation.find_or_create_by_user_id_and_artist_id(user.id, artist.id)
      artist
    end

    def find_or_create prop
      artist = find_or_create_by_mbid(prop[:mbid], name: prop[:name], mbid: prop[:mbid],listeners: prop[:listeners] || 0)
      (artist.photo = photo_from_url(prop[:image]); artist.save()) unless artist.photo.exists?
      artist
    end
  end
end
