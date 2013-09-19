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
    base.extend ClassMethods
  end

  module ClassMethods
    def logger(&b)
      info "Task started"
      begin
        real = Benchmark.realtime { yield } if block_given?
      rescue Exception => e
        error "Task aborted:"
        error "In: #{e.class.to_s}, #{e.message}"
        error "Backtrace: #{e.backtrace}"
        #TODO test compatible with resque error-handler
        raise e
      end
      info "Task completed, elapsed time: #{real.round(5)} s" if real
    end

    def read_log
      ScheduleLog.where(:job_class => self.inspect).sort(:created_at.desc).all.inject('') {|sum, n| sum << "[ #{n.status.upcase}: #{n.created_at.strftime('%H:%M:%S %d-%m-%Y')} ] #{n.content}\n" }
    end

    def debug(message); ScheduleLog.create(:status => 'debug', :content => message, :job_class => self.inspect); end
    def info(message); ScheduleLog.create(:status => 'info', :content => message, :job_class => self.inspect); end
    def warn(message);  ScheduleLog.create(:status => 'warn', :content => message, :job_class => self.inspect); end
    def error(message); ScheduleLog.create(:status => 'error', :content => message, :job_class => self.inspect); end
  end
end
