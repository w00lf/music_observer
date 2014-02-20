class Tag < ActiveRecord::Base
  attr_accessible :api_link, :name
  has_and_belongs_to_many :artists

  class << self
    def top_recommended(user)
      select('tags.*, count(artists_tags.artist_id)')
      .joins(:artists => :recommendations)
      .where(['artist_users.user_id = ?', user.id]).group('tags.id')
      .order('count(artists_tags.artist_id) DESC')
    end
  end
end
