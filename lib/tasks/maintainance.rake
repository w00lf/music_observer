namespace :maintainance do
 desc "Check whenever delayed job script is running or not"
  task :worker => :environment do
  	include ScheduledTasksLogger
  	begin
  		delayed_job_pid = File.new(File.join(Rails.root, 'tmp', 'pids', 'delayed_job.pid')).read.to_i
  		Process.getpgid( delayed_job_pid )
  	rescue 
  		info 'Cannot find worker by pid, atempting to start worker'
  		script_obj = DelayedScript.new('start')
  		if script_obj.can_launch
  			script_obj.perform
  			info 'Started new worker'
  		else
  			error('Fatal, exceeded starts limit for worker, waiting next hour to repeat') 
  		end
  	end
  end
end
