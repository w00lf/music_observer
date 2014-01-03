class ChangeLengthLimitsForColumns < ActiveRecord::Migration
  def up
  	change_column :tags, :name, :string, :limit => 10000
  	change_column :tags, :api_link, :string, :limit => 10000
  	change_column :artists, :api_link, :string, :limit => 10000

  end

  def down
  end
end
