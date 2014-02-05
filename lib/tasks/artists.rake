namespace :artists do
  desc "Scan lastfm api for artists information(start date, tags and so on)"
  task :scan_info => :environment do
  	ArtistInfoScanner.new.perform
  end
end
