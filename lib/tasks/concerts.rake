namespace :concerts do
  desc "create concerts from api call"
  task :add => :environment do
    ConcertScanner.perform
  end
end
