class Artist < ActiveRecord::Base
  attr_accessible :api_id, :mbid, :name, :track
  attr_accessible :photo
  validates :name, :mbid, :api_id, presence: true

  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
end
