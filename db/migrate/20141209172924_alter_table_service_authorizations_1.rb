class AlterTableServiceAuthorizations1 < ActiveRecord::Migration
  def up
  	 add_column :service_authorizations, :status, :integer
  end
end
