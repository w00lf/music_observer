class ScheduleLogsController < ApplicationController
  layout 'side_bar'
  
   def index
    status = params[:status]
    start_date, end_date = params[:date_from], params[:date_to]
    @job_classes = ScheduledTask.pluck(:job_class)
    @job_classes << 'LastFmApi'
    @items = ScheduleLog
    @items = ScheduleLog.get_logs(params[:job_class], status, start_date, end_date) unless params[:job_class].blank?
    @items = @items.paginate(:page => params[:page], :per_page => params[:per_page] || 30)
   end
end
