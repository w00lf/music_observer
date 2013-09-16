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
    		"Concerts" => concerts_path
    	}
    end
end
