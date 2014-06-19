class UserRecomendationsParser
  include ScheduledTasksLogger
  # @queue = :scheduled_tasks

  def perform(last_fm_login, session_key, user_id)
    logger do
      counter = 0 
      user = User.find(user_id)
      @api = LastFmApi.new
      @api.parse_recomendations(last_fm_login, session_key) do |art|
        (warn "max library parse size reached, user :#{user.id}, lastfm user: #{last_fm_login}"; break) if counter > @api.class::MAX_LIBRARY
        begin
          artist = Artist.find_or_create(art)
          unless user.artists_recommendations.exists?(artist)
            user.recommendations.create(artist_id: artist.id)
            info "created recommendation: #{artist.name}, for user: #{user.id}, lastfm user: #{last_fm_login}"
          end
        rescue ActiveRecord::RecordInvalid => e
          warn "cannot create artist: #{art[:name]}/#{art[:mbid]}, reason: #{e.message}, when parsing recomendations for lastfm user: #{last_fm_login}"
        end
        counter += 1
      end
      ArtistInfoScanner.new.perform
    end
  end
end