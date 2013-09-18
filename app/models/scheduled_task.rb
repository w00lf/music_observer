class ScheduledTask < ActiveRecord::Base
  validates_presence_of :cron, :job_class, :queue, :name
  attr_accessible :cron, :job_class, :queue, :name, :description, :args

  def self.get_schedule_hash
    hash = {}
    all.each do |entry|
      hash[entry.name] = {
        "class" => entry.job_class, 
        "description" => entry.description, 
        "cron" => entry.cron, 
        "queue" => entry.queue,
        "args" => entry.args
      }
    end
    hash
  end
end
