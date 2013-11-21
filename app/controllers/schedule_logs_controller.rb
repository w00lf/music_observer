class ScheduleLogsController < ApplicationController
  layout 'side_bar'
  
   def index
    @job_classes = ScheduleLog.distinct(:job_class)
    if params[:job_class].blank?
      @items = ScheduleLog.paginate(page: params[:page], per_page: params[:per_page])
    else
      @items = ScheduleLog.get_logs(params[:job_class], params[:status], params[:date_from], params[:date_to], params[:page], params[:per_page] || 30)
    end
   end
end