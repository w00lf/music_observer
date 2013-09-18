class ScheduleLogsController < ApplicationController
   def index
    @items = ScheduleLog.all
    @job_classes = ScheduledTask.pluck(:job_class)
    @job_classes << LastFmApi
   end
end
