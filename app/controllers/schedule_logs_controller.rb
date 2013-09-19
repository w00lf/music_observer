class ScheduleLogsController < ApplicationController
   def index
    @items = ScheduleLog.order('_id DESC')
    @items = @items.where(job_class: params[:job_class])  unless params[:job_class].blank?
    @items = @items.paginate(page: (params[:page] || 1), per_page: (params[:pre_page] || 20))
    @job_classes = ScheduledTask.pluck(:job_class)
    @job_classes << 'LastFmApi'
   end
end
