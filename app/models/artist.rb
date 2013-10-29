class Artist < ActiveRecord::Base
  attr_accessible :mbid, :name, :track
  attr_accessible :photo
  acts_as_taggable

  validates :name, :mbid, presence: true
  validates :name, :mbid, uniqueness: true

  has_many :concerts
  has_many :artist_user_entries, dependent: :destroy
  
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  def self.create_artist(prop, user)
    artist = self.find_by_mbid(prop[:mbid])
    if artist.nil?
      artist = self.create(name: prop[:name], 
                    mbid: prop[:mbid],
                    listeners: prop[:listeners])
      artist.photo = self.photo_from_url( prop[:image] )
      artist.save()
    end
    artist.artist_user_entries.create(track: prop[:track] || false, user: user) unless user.artists.find_by_id(artist)     
    artist
  end

  extend ApplicationHelper
end
