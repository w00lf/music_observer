class ArtistInfoScanner
  include ScheduledTasksLogger
  # @queue = :scheduled_tasks


  def perform
    do_retrive()
  end

  def do_retrive(force = false)
    logger do
      @api = LastFmApi.new
      last_time_parsed_obj = ScheduleLog.where(entry_type: "job_started", job_class: self.class).first # if task ended prematurely???
      last_time_parsed = last_time_parsed_obj.nil? || force ? 1000.years.ago : last_time_parsed_obj.created_at
      Artist.find_each(conditions: ['mbid IS NOT ? AND created_at > ?', nil, last_time_parsed], batch_size: 100) do |artist|
        stats = @api.get_artist_info(artist.mbid, 'en')
        if stats.blank?
          error("Cannot get stats for artst #{artist.id}")  
          next
        end
        tags_stats = stats.delete(:tags)
        if artist.update_attributes(stats)
          info("Writed attributes for artist: #{artist.id}/#{artist.name}")
        else
          error("Cannot update attributes for artist: #{artist.id}/#{artist.name}")
        end
        tags_stats.each do |tag|
          artist.tags << Tag.find_or_create_by_name(tag)
        end
        sleep(0.2)
      end
    end
  end
end