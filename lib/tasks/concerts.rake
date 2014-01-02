namespace :concerts do
  desc "create concerts from api call"
  task :add => :environment do
    ConcertScanner.new.perform
  end
end
