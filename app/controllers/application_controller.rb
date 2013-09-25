class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!

  @@api_provider = LastFmApi

  def current_user
    @current_user ||= super && User.includes(:concert_user_entries, :concerts).find(@current_user.id)
  end
end
