class AlterServiceAuthorization4 < ActiveRecord::Migration
  def change
  	change_column :service_authorizations, :provider_id,:integer,null:true
  end
end
