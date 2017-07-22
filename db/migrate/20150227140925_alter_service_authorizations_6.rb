class AlterServiceAuthorizations6 < ActiveRecord::Migration
  def change
  	add_column :service_authorizations, :notes, "text"
  end
end
