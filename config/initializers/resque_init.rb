require 'resque'
require 'resque_scheduler'
require 'resque/scheduler'      

rails_env = Rails.env || 'development'
yml_data = YAML.load_file(File.join(Rails.root, '/config/resque.yml'))
resque_config = URI.parse(yml_data[rails_env])
Resque.redis = Redis.new(:host => resque_config.host, :port => resque_config.port)
Resque.schedule = YAML.load_file("#{Rails.root}/config/rescue_schedule.yml")
Dir["#{Rails.root}/lib/jobs/*.rb"].each { |file| require file }