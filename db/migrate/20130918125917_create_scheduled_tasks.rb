class CreateScheduledTasks < ActiveRecord::Migration
  def change
    create_table :scheduled_tasks do |t|
      t.string :cron
      t.string :name
      t.string :queue
      t.text :description
      t.string :job_class
      t.string :args

      t.timestamps
    end
  end
end
