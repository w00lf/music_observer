namespace :schedule do
  desc "load jobs schedule from config/resque_schedule.yml"
  task :init => :environment do
    schedule = YAML.load_file(File.join(Rails.root, 'config/resque_schedule.yml'))
    schedule.each do |name, job|
      next if ScheduledTask.find_by_name(name)
      ScheduledTask.create(
                        :description => job['description'], 
                        :cron => job['cron'], 
                        :job_class => job['class'], 
                        :name => name,
                        :queue => job['queue'],
                        :args => job['args']
                  )
    end
  end
end
