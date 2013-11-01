class ScheduleLogsController < ApplicationController
  layout 'side_bar'
  
   def index
    @statuses = ScheduleLog.get_statuses
    status = params[:status]
    start_date, end_date = params[:date_from], params[:date_to]
    @job_classes = ScheduledTask.pluck(:job_class)
    @job_classes.push(@@api_provider,@@api_provider_aut)
    if params[:job_class].blank?
      @items = ScheduleLog.paginate(page: params[:page], per_page: params[:per_page])
    else
      @items = ScheduleLog.get_logs(params[:job_class], status, start_date, end_date, params[:page], params[:per_page] || 30)
    end
   end
end