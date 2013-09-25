class Artist < ActiveRecord::Base
  attr_accessible :mbid, :name, :track
  attr_accessible :photo

  validates :name, :mbid, presence: true
  validates :name, :mbid, uniqueness: true

  has_many :concerts
  has_many :artist_user_entries, dependent: :destroy
  
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  extend ApplicationHelper
end
