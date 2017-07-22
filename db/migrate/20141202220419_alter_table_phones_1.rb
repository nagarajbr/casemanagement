class AlterTablePhones1 < ActiveRecord::Migration
  def up
  	rename_column :phones, "number", :phone_number
  	remove_column :phones, :client_id
  end
end
