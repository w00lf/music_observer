class AddIndexesToConcerts < ActiveRecord::Migration
  def change
    add_index :concerts, [:title, :created_at]
  end
end
