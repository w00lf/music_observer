class Artist < ActiveRecord::Base
  attr_accessible :mbid, :name, :track
  attr_accessible :photo

  validates :name, :mbid, presence: true
  validates :name, :mbid, uniqueness: true

  has_many :concerts
  has_many :artist_user_entries, dependent: :destroy
  
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  def self.create_artist(prop, user)
    artist = self.find_by_mbid(prop[:mbid])
    if artist.nil?
      artist = self.create(name: prop[:name], 
                    mbid: prop[:mbid])
      artist.photo = self.photo_from_url( prop[:image] )
      artist.save()
    end
    artist.artist_user_entries.create(track: prop[:track] || false, user: user) unless user.artist_user_entries.find_by_artist_id(Artist.last)     
    artist
  end

  extend ApplicationHelper
end
