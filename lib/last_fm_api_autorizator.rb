class LastFmApiAutorizator < LastFmApi
  @@session_key = ''
  @@lastfm_user = ''
  class << self
    def check_callback(session, params)
      unless (token = params[:token]).blank?
        if fetch_session(token)
          session[:auth] = {}
          session[:auth][:api_sig] = @@session_key 
          session[:auth][:username] = @@lastfm_user
        end
      end
    end

    def fetch_session token
      responce = {}
      logger do
        signature = Digest::MD5.hexdigest("api_key#{LASTFM_KEY}methodauth.getSessiontoken#{token}#{LASTFM_SECRET}")
        params = { token: token, api_key: LASTFM_KEY, api_sig: signature, method: 'auth.getSession' }
        debug "processing fetch session for token: #{token}"
        responce = get_request(params)

        unless responce.blank? || !responce['error'].blank?
          @@session_key = responce['session']['key']
          debug "session key: #{@@session_key}"
          @@lastfm_user = responce['session']['name']
        else
          debug responce.inspect
        end
      end
      return true if responce['error'].nil?
    end

    def get_username(session)
      session[:auth][:username] unless session[:auth].blank?
    end

    def need_auth?(session)
      session[:auth].blank? || session[:auth][:api_sig].blank?
    end

    def autenticate_redirect
      "http://www.last.fm/api/auth/?api_key=#{LASTFM_KEY}"
    end

  end
end