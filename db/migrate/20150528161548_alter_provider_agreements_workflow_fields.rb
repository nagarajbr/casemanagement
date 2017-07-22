class AlterProviderAgreementsWorkflowFields < ActiveRecord::Migration
  def change
  	add_column :provider_agreements, :requested_by, :integer
  	add_column :provider_agreements, :requested_date, :datetime
  	add_column :provider_agreements, :approved_by, :integer
  	add_column :provider_agreements, :approved_date, :datetime
  	add_column :provider_agreements, :rejected_by, :integer
  	add_column :provider_agreements, :rejected_date, :datetime
  end
end
