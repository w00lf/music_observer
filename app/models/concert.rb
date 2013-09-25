class Concert < ActiveRecord::Base
  attr_accessible :api_link, :artist, :country, :description, :sity, :start_date, :street, :title, :api_id
  validates :api_link, :start_date, :title, :artist, :api_id, :presence => true
  has_many :concert_user_entries, dependent: :destroy
  belongs_to :artist

  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  
  extend ApplicationHelper

  scope :actual_concerts, lambda {|interval_string|  
  	interval = get_interval(interval_string)
  	order('start_date').where(['start_date BETWEEN ? AND ?', interval[0], interval[1]])
  }
  scope :is_show, where(['concert_user_entries.is_show = ?', true ])

  private 

  def self.get_interval interval_string
  	if interval_string.blank?
  		return [Time.now, (Time.now + 1.year)]
  	end
  	[Time.parse(interval_string.split('-')[0]), Time.parse(interval_string.split('-')[1])]
  end
end
