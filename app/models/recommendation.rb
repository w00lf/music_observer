class Recommendation < ArtistUser
  attr_accessible :artist_id, :user_id, :show
  belongs_to :user
  belongs_to :artist

  scope :publick, where(show: true)
  
  scope :artists_date_range, lambda {|year_from, year_to|
    year_from = year_from.blank? ? 1000.years.ago : Time.new(year_from)
    year_to = year_to.blank? ? Time.now : Time.new(year_to)
    joins(:artist).where([  'artists.year_from > ? 
              AND (
                artists.year_to < ? OR 
                artists.year_to IS ?
              )', 
              year_from, 
              year_to, 
              nil])
  }
  scope :artists_more_than_listens, lambda {|count|
    joins(:artist).where([ 'artists.listeners > ?', count])
  }
  scope :artists_tagged_with, lambda {|tag_id|
    joins(:artist => :tags ).where(['tags.id = ?', tag_id])
  }
end
