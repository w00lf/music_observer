class AddIsShowedAndUserIdToConcerts < ActiveRecord::Migration
  def change
    add_column :concerts, :is_showed, :boolean, default: true
    add_column :concerts, :user_id, :integer
  end
  Concert.update_all(:is_showed => true, :user_id => User.last.id) unless User.last.nil?
end
