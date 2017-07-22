class AddCurrentlyWorkingFlagToClient < ActiveRecord::Migration
  def change
  	add_column :clients, :currently_working_flag, :string, limit: 1
  end
end
