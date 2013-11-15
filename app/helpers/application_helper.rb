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
    		Favorite.model_name.human(:count => 1000) =>  artists_path, 
    		Concert.model_name.human(:count => 1000) => concerts_path,
            Recommendation.model_name.human(:count => 1000) => recommendations_path,
            ScheduleLog.model_name.human(:count => 1000) => schedule_logs_path
    	}
    end

    def api_auth
       url_for(controller: 'api_session', action: 'outside_request', return_url: request.url ) 
    end

    def link_to_or_authorize api_authorized, target_tag
        return target_tag if api_authorized
        link_to(t('.add_from_own_library'), api_auth, confirm: t('.authorize_api'))
    end

    def model_page_title(entry)
        t('.title', :default => entry.class.model_name.human(count: 1000).titleize)
    end
end
