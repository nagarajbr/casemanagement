class AlterClientApplicationTable5 < ActiveRecord::Migration
  def up
  	add_column :client_applications, :registered_date, :date
  	add_column :client_applications, :disposition_date, :date
  	  	
  end
end
