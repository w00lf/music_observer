class CreateConcertUserEntries < ActiveRecord::Migration
  def change
    create_table :concert_user_entries do |t|
      t.integer :concert_id
      t.integer :user_id
      t.boolean :is_show, null: false, default: true
    end
  end
end
