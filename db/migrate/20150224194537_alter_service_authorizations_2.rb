class AlterServiceAuthorizations2 < ActiveRecord::Migration
  def change
  	add_column :service_authorizations, :supportive_service_flag, "char(1)"
  end
end
