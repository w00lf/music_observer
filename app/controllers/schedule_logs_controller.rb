class ScheduleLogsController < ApplicationController
  layout 'side_bar'
  
   def index
    status = params[:status]
    start_date, end_date = params[:date_from], params[:date_to]
    @job_classes = ScheduledTask.pluck(:job_class)
    @job_classes << 'LastFmApi'
    @items = ScheduleLog.paginate(page: params[:page], per_page: params[:per_page])
    @items = ScheduleLog.get_logs(params[:job_class], status, start_date, end_date, params[:page], params[:per_page] || 30) unless params[:job_class].blank?
   end
end