class ConcertUserEntry < ActiveRecord::Base
  attr_accessible :concert, :is_show, :user
  belongs_to :user
  belongs_to :concert

  validates :concert, :user, presence: true
end
