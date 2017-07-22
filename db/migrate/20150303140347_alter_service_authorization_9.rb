class AlterServiceAuthorization9 < ActiveRecord::Migration
  def change
  	change_column :service_authorizations, :service_start_date, "date",null:true
  	change_column :service_authorizations, :service_end_date, "date",null:true
  end
end
