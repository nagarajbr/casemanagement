class AlterServiceAuthorizationLineItemsWorkflowFields < ActiveRecord::Migration
  def change
  		add_column :service_authorization_line_items, :requested_by, :integer
	  	add_column :service_authorization_line_items, :requested_date, :datetime

  		add_column :service_authorization_line_items, :status_updated_by, :integer
  		add_column :service_authorization_line_items, :status_updated_date, :datetime
  		add_column :service_authorization_line_items, :status_rejection_reason, :string
  end
end
