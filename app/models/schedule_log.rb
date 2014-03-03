class ScheduleLog
  include Mongoid::Document
  include Mongoid::Timestamps
  extend Enumerize

  default_scope order_by(_id: -1)

  field :job_class, type: String
  field :status, type: String
  enumerize :status, in: [:debug, :info, :warn, :error], default: :info
  field :content, type: String
  field :entry_type
  enumerize :entry_type, in: [:job_started, :job_ended, :entry], default: :entry

  def self.get_logs tasks, status, start_date, end_date, page, limit 
    query = { "job_class" => { "$in" => tasks } }
    query.merge!({ status: status }) unless status.blank?
    date_range = { created_at: {}}
    date_range[:created_at].merge!({:$gte => Time.parse(start_date)}) unless start_date.blank?
    date_range[:created_at].merge!({:$lte => Time.parse(end_date)}) unless end_date.blank?
    query.merge!(date_range) unless date_range[:created_at].blank?
    self.where(query).paginate(page: page, per_page: limit)
  end
end
