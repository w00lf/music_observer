class CreateConcerts < ActiveRecord::Migration
  def change
    create_table :concerts do |t|
      t.string :title
      t.text :description
      t.string :api_link
      t.string :country
      t.string :sity
      t.string :street
      t.integer :artist_id
      t.datetime :start_date
      t.integer :api_id

      t.timestamps
    end
    add_attachment :concerts, :photo
  end
end
