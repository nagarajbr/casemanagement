class AlterServiceAuthorizations5 < ActiveRecord::Migration
  def change
  	add_column :service_authorizations, :barrier_id, "integer"
  end
end
