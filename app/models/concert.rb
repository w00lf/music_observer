class Concert < ActiveRecord::Base
  attr_accessible :api_link, :artist, :country, :description, :sity, :start_date, :street, :title, :api_id
  validates :api_link, :start_date, :title, :artist, :api_id, :presence => true
  belongs_to :artist
end
