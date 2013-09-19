module ApplicationHelper
	def photo_from_url(url)
		return if url.blank?
        extname = File.extname(url)
        basename = File.basename(url, extname)

        file = Tempfile.new([basename, extname])
        file.binmode

        open(URI.parse(url)) do |data|  
          file.write data.read
        end

        file.rewind
        file
    end

    def get_top_menu_items
    	{
    		"Artists" =>  artists_path, 
    		"Concerts" => concerts_path,
            "Statistics" => schedule_logs_path
    	}
    end

    def get_pid(pid_file)
        File.read(pid_file) rescue nil
    end

    def get_worker_pid
        get_pid(SCHEDULED_TASKS_PID)
    end

    def get_scheduler_pid
        get_pid(SCHEDULER_PID)
    end
    def worker
        Resque::Worker.all.select { |worker| worker.id.match(/scheduled_tasks/) }.first
    end

    def worker_processing     
        if worker && worker.processing.present?
          worker.processing['payload']['class']
        else
          "Waiting for a job"
        end
    end

    def worker_run_at
        if worker && worker.processing.present?
          worker.processing['run_at']
        else
          '--:--'
        end
    end

    def last_failed
        Resque::Failure.all(-1)["payload"]["class"]
    end
end
