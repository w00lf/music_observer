class ScheduleLogsController < ApplicationController
  
  def index
    @job_classes = ScheduleLog.distinct(:job_class)
    @delay_jobs_stat = delay_jobs_stat
    if params[:job_classes].blank?
      @items = ScheduleLog.paginate(page: params[:page], per_page: params[:per_page])
    else
      @items = ScheduleLog.get_logs(params[:job_classes], params[:status], params[:date_from], params[:date_to], params[:page], params[:per_page] || 30)
    end
   end

  def destroy
    Delayed::Job.destroy_all
    respond_to do |format|
      format.html { flash[:success] = t(:success); redirect_to :back }
      format.json { render json: { title: t(:success), message: t(:cleared) } }
    end
   end
private
    def delay_jobs_stat
      {
        'Jobjs in queue: ' => Delayed::Job.all.count,  
        'Failed jobs in queue' => Delayed::Job.where(:last_error.ne => nil, :last_error.exists => true).count,
        'Job last_error' => Delayed::Job.where(:last_error.ne => nil, :last_error.exists => true).last.try { |n| last_error.split("\n").join("<br>") }
      }
    end
end