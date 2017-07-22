class AlterTableServiceAuthorizations3 < ActiveRecord::Migration
  def change
  	add_column :service_authorizations, :service_type, :integer
  end
end
