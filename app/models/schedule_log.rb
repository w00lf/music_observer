class ScheduleLog
  Statuses = ['debug', 'info', 'warn', 'error']
  include Mongoid::Document
  include Mongoid::Timestamps
  validate :right_status
  default_scope order_by(_id: -1)

  field :job_class, type: String
  field :status, type: String
  field :content, type: String

  def self.get_logs task, status, start_date, end_date, page, limit 
    query = { job_class: task }
    query.merge!({ status: status }) unless status.blank?
    date_range = { created_at: {}}
    date_range[:created_at].merge!({:$gte => Time.parse(start_date)}) unless start_date.blank?
    date_range[:created_at].merge!({:$lte => Time.parse(end_date)}) unless end_date.blank?
    query.merge!(date_range) unless date_range[:created_at].blank?
    self.where(query).paginate(page: page, per_page: limit)
  end

  def self.get_statuses
    Statuses
  end

  private
  def right_status
    errors.add(:status, 'Wrong status format')  unless Statuses.include? status
  end
end
