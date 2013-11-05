module ApplicationHelper
	def photo_from_url(url)
		return if url.blank?
        extname = File.extname(url)
        basename = File.basename(url, extname)

        file = Tempfile.new([basename, extname])
        file.binmode

        open(URI.parse(url)) do |data|  
          file.write data.read
        end

        file.rewind
        file
    end

    def get_top_menu_items
    	{
    		"Artists" =>  artists_path, 
    		"Concerts" => concerts_path,
            "Statistics" => schedule_logs_path
    	}
    end

    def api_auth
       url_for(controller: 'api_session', action: 'outside_request', return_url: request.url ) 
    end

    def link_to_or_authorize api_authorized, target_tag
        return target_tag if api_authorized
        link_to(t('.add_from_own_library'), api_auth, confirm: t('.authorize_api'))
    end
end
