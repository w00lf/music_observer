ActiveAdmin.register_page "Schedule Logs" do
  job_classes = ScheduleLog.distinct(:job_class)
  delay_jobs_stat = {
    'Jobjs in queue: ' => Delayed::Job.all.count,  
    'Failed jobs in queue' => Delayed::Job.where(:last_error.ne => nil, :last_error.exists => true).count,
    'Job last_error' => Delayed::Job.where(:last_error.ne => nil, :last_error.exists => true).last.try { |n| last_error.split("\n").join("<br>") }
  }
  items = ScheduleLog.paginate(page: 1, per_page: 10)

  content :title => proc{ I18n.t("activerecord.models.schedule_log.one") }  do
    table_for items do
      column "Status" do |item| 
        status_tag('OK', :ok)
      end
      column "Content" do |item| 
        item.content
      end
    end
  end
end