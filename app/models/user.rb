class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  has_many :concert_user_entries, dependent: :destroy, :uniq => true
  has_many :favorites, dependent: :destroy, :uniq => true
  has_many :recommendations, dependent: :destroy, :uniq => true

  has_many :artists_favorites, through: :favorites, source: :artist, conditions: { artist_users: { type: "Favorite" } }, :uniq => true
  has_many :artists_recommendations, through: :recommendations, source: :artist, conditions: { artist_users: { type: "Recommendation" } }, :uniq => true
  # has_many :libraries, :through => :artist_users, :source => :link, :source_type => 'Library'
  # has_many :libraries, conditions: { artist_users: { link_type: "Library" } }, class_name: 'Library'
  has_many :concerts, through: :concert_user_entries 
end
