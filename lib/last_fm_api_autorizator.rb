class LastFmApiAutorizator < LastFmApi

  def initialize session
    @session = session[:auth]
    @session_key = ''
    @lastfm_user = ''
    @signature = ''
  end

  def check_callback params, session # TODO change method, add session object, @session is no more a session object
    unless (token = params[:token]).blank?
      if fetch_session(token)
        session[:auth] = {}
        session[:auth][:session_key] = @session_key 
        session[:auth][:username] = @lastfm_user
        # session[:auth][:api_sig] = @signature 
      end
    end
  end

  def fetch_session token
    responce = {}
    logger do
      make_signature( "api_key" => LASTFM_KEY, "method" => 'auth.getSession', 'token' => token)
      
      params = { token: token, api_key: LASTFM_KEY, api_sig: @signature, method: 'auth.getSession' }
      debug "processing fetch session for token: #{token}"
      responce = get_request(params)

      unless responce.blank? || !responce['error'].blank?
        @session_key = responce['session']['key']
        debug "session key: #{@session_key}"
        @lastfm_user = responce['session']['name']
      else
        debug responce.inspect
      end
    end
    return true if responce['error'].nil?
  end

  def make_signature args
    debug "what we get: *#{args.sort.flatten.join}#{LASTFM_SECRET}*"
    @signature = Digest::MD5.hexdigest("#{args.sort.flatten.join}#{LASTFM_SECRET}")
  end

  def get_username
    @session[:username] unless @session.blank?
  end

  def get_session_key
    @session[:session_key] unless @session.blank?
  end

  def need_auth?
    @session.blank? || @session[:session_key].blank?
  end

  def autenticate_redirect
    "http://www.last.fm/api/auth/?api_key=#{LASTFM_KEY}"
  end
end