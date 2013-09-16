class Artist < ActiveRecord::Base
  attr_accessible :mbid, :name, :track
  attr_accessible :photo
  validates :name, :mbid, presence: true
  validates :name, :mbid, uniqueness: true
  default_scope order('created_at DESC')
  has_many :concerts

  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"

  extend ApplicationHelper
end
