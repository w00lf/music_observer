class Tag < ActiveRecord::Base
  attr_accessible :api_link, :name
  has_and_belongs_to_many :artists

  class << self
    def top_recommended(user)
      select('tags.*, count(artists_tags.artist_id) as artist_count')
      .joins(:artists => :recommendations)
      .where(['artist_users.user_id = ? AND artist_users.type = ?', user.id, Recommendation]).group('tags.id')
      .order('artist_count DESC')
    end
  end
end