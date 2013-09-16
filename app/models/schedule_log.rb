class ScheduleLog
  Statuses = ['debug', 'info', 'warn', 'error']
  include MongoMapper::Document
  validate :right_status

  key :job_name,     String
  key :status,       String
  key :content,      String
  timestamps!

  def self.get_logs task, status, start_date, end_date 
    query = where(:job_name => task).sort(:_id.desc)
    query = query.where(:status => status) unless status.blank?
    query = query.where(:created_at => { '$gt' => Time.parse(start_date), '$lt' => Time.parse(end_date) }) unless start_date.blank? || end_date.blank?
    query
  end

  def self.get_statuses
    Statuses
  end

  private
  def right_status
    errors.add(:status, 'Wrong status format')  unless Statuses.include? status
  end
end
