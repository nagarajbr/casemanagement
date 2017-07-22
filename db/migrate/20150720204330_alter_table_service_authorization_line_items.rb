class AlterTableServiceAuthorizationLineItems < ActiveRecord::Migration
  def change
  	remove_column :service_authorization_line_items, :status
  	remove_column :service_authorization_line_items, :requested_by
  	remove_column :service_authorization_line_items, :requested_date
  	remove_column :service_authorization_line_items, :approved_by
  	remove_column :service_authorization_line_items, :approved_date
  	remove_column :service_authorization_line_items, :status_updated_by
  	remove_column :service_authorization_line_items, :status_updated_date
  	rename_column :service_authorization_line_items, :status_rejection_reason, :reason
  	add_column :service_authorization_line_items, :state, :integer
  end
end
