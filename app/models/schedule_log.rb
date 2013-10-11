class ScheduleLog
  Statuses = ['debug', 'info', 'warn', 'error']
  include Mongoid::Document
  include Mongoid::Timestamps
  validate :right_status

  field :job_class, type: String
  field :status, type: String
  field :content, type: String

  def self.get_logs task, status, start_date, end_date, page, limit 
    query = { job_class: task }
    query.merge({ status: status }) unless status.blank?
    query.merge({ created_at: { '$gt' => Time.parse(start_date), '$lt' => Time.parse(end_date) } }) unless start_date.blank? || end_date.blank?
    self.paginate(page: page, limit: limit, conditions: query, sort: :_id.desc)
  end

  def self.get_statuses
    Statuses
  end

  private
  def right_status
    errors.add(:status, 'Wrong status format')  unless Statuses.include? status
  end
end
