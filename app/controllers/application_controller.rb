class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :check_api_callback

  @@api_provider = LastFmApi
  @@api_provider_aut = LastFmApiAutorizator

  def check_api_callback
    @@api_provider_aut.check_callback( session, params )
  end

  def current_user
    @current_user ||= super && User.includes(:concert_user_entries, :concerts).find(@current_user.id)
  end
end
