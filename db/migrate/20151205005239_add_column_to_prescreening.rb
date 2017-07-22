class AddColumnToPrescreening < ActiveRecord::Migration
  def change
  	add_column :prescreen_households, :intake_worker, :string
  end
end
