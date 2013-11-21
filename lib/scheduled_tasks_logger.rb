module ScheduledTasksLogger
  require 'benchmark'

  def self.included(base)
    log_path = File.join(Rails.root, 'log', 'scheduled_tasks')
    log_filename = File.join(log_path, base.to_s.underscore + '.log')
    base.class_eval <<-EOF
      cattr_accessor :_logger
      @@_logger = Logger.new(STDOUT)
      @@_logger.level = Logger::DEBUG
      @@_logger.formatter = proc {|sev, date, prog, msg| "[\#{date.strftime("%d-%m-%Y %H:%M:%S")}] -- \#{sev} : \#{msg}\n" }
    EOF
  end

  def logger(&b)
    info("Task started", "job_started")
    begin
      real = Benchmark.realtime { yield } if block_given?
    rescue Exception => e
      error "Task aborted:"
      error "In: #{e.class.to_s}, #{e.message}"
      error "Backtrace: #{e.backtrace.join('<br>')}"
      raise e
    end
    info("Task completed, elapsed time: #{real.round(5)} s", 'job_ended') if real
  end

  ::ScheduleLog.status.values.each do |status| 
    define_method(status) do |*args| 
      message = args[0]
      entry_type = args[1] || 'entry'
      ScheduleLog.create(status: status, content: message, job_class: self.class, entry_type: entry_type);
    end
  end
end
