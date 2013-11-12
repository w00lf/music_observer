class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :check_api_login

  def api_auth
    session[:return_url] = request.url
    redirect_to '/api_session/outside_request'
  end

  def redirect_last_requested_url
    session[:return_url].blank? ? redirect_to(:root) : redirect_to(session[:return_url])
  end

  def current_user
    @current_user ||= super && User.includes(:concert_user_entries, :concerts).find(@current_user.id)
  end

  def check_api_login
    @api_provider = LastFmApi.new
    @api_provider_aut = LastFmApiAutorizator.new(session)
    @api_authorized = !@api_provider_aut.need_auth?()   
  end
end
