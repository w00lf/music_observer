class Artist < ActiveRecord::Base
  attr_accessible :mbid, :name, :track, :listeners, :photo
  acts_as_taggable

  validates :name, :mbid, presence: true
  validates :name, :mbid, uniqueness: true

  default_scope order(:created_at)

  has_many :concerts
  has_many :favorites, dependent: :destroy
  has_many :recommendations, dependent: :destroy
  # has_many :libraries, :through => :artist_users, :source => :link, :source_type => 'Library'

  has_many :users_favorites,  through: :favorites, source: :artist, conditions: { artist_users: { type: "Favorite" } }, :uniq => true
  has_many :users_recommendations, through: :recommendations, source: :artist, conditions: { artist_users: { type: "Recommendation" } }, :uniq => true
  
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

  def self.filter from, to
    to = to.blank? ?  Time.now : Time.parse(to)
    from = from.blank? ?  minimum(:created_at) : Time.parse(from)
    where(['artists.created_at BETWEEN ? AND ?', from, to])
  end

  def toggle_library_entry user, visibl
    artist_users.find_by_user_id(user).link.update_attribute(:track, visibl)
  end

  extend ApplicationHelper
end
