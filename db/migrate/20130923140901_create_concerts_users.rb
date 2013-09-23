class CreateConcertsUsers < ActiveRecord::Migration
  def change
    create_table :concerts_users do |t|
      t.integer :concert_id
      t.integer :user_id
    end
  end
end
