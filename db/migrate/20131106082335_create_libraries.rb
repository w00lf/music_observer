class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.boolean :track, null: false, default: false
      t.integer :listened, null: false, default: 0
      t.boolean :show, null: false, default: true

      t.timestamps
    end
  end
end
