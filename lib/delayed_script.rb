require 'delayed/command'

class WrappedCommnad < Delayed::Command
  def run(worker_name = nil)
    ActiveRecord::Base.connection.reconnect!
    super(worker_name)
  end
end

class DelayedScript
	include ScheduledTasksLogger

	def initialize(*additional_args)
		@args = (additional_args + ARGV).uniq
		ENV['RAILS_ENV'] ||= 'production'
	end

	def perform
		logger do
			WrappedCommnad.new(@args).daemonize
		end
	end

	def can_launch
		return true if started_per(1.hour.ago..Time.now) < 10
	end

	def started_per(range)
		ScheduleLog.where(entry_type: "job_ended", job_class: self.class).between(created_at: range).count
	end
end