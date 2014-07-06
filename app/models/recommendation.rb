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

  class << self
    def filter(query, user)
      user_recom = select('DISTINCT "artist_users".*, "artists".*').includes(:artist).where(user_id: user.id).publick
      user_recom = user_recom.order('artist_users.created_at desc') unless query.try(:[], :s).present?
      tags = []
      query ||= {}
      search_attributes = {}
      if query.present? && query[:tagged_with].present?
        tags = query[:tagged_with].reject {|n| n.blank? }
        artist_ids = Artist.joins(:tags).select('artists.id, count(*) as taging').where(['tags.id in(?)', tags]).group('artists.id').having(['count(*) > ?', (tags.length - 1)]).map(&:id)
        artist_ids = [0] if artist_ids.blank?
        search_attributes.merge!(artist_id_in: artist_ids)
      end
      user_recom.search(query.merge(search_attributes))
    end
  end
end
