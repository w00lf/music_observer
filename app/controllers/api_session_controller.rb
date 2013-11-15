class ApiSessionController < ApplicationController
  def outside_request
    return redirect_last_requested_url() unless @api_provider_aut.need_auth?() 
    session[:return_url] = params[:return_url]
    redirect_to @api_provider_aut.autenticate_redirect
  end

  def return_callback
    @api_provider_aut.check_callback(params, session)
    redirect_last_requested_url()
  end
end