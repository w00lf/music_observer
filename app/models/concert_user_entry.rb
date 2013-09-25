class ConcertUserEntry < ActiveRecord::Base
  attr_accessible :concert, :is_show, :user
  belongs_to :user
  belongs_to :concert

  validates :concert, :user, presence: true

  def self.get_user_concert_entry concert, user
    concert.concert_user_entries.find_by_user_id(user) 
  end
end
