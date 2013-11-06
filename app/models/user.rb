class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  
  has_many :artist_users, dependent: :destroy
  has_many :concert_user_entries, dependent: :destroy
  has_many :artists, through: :artist_users, :conditions => '"artist_users"."link_type" = \'Library\'' do 
    def tracked
      joins(:libraries).where(['libraries.track = ?', true])
    end

    def visible
      joins(:libraries).where(['libraries.show = ?', true])
    end
  end
  # has_many :libraries, :through => :artist_users, :source => :link, :source_type => 'Library'
  # has_many :libraries, conditions: { artist_users: { link_type: "Library" } }, class_name: 'Library'
  has_many :concerts, through: :concert_user_entries 
end
