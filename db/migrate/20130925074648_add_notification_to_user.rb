class AddNotificationToUser < ActiveRecord::Migration
  def change
    add_column :users, :notification, :boolean, null: false, default: false
  end
end
