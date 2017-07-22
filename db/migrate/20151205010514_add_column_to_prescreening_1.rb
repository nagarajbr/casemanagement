class AddColumnToPrescreening1 < ActiveRecord::Migration
  def change
  	add_column :prescreen_households, :processing_location, :integer
  end
end
