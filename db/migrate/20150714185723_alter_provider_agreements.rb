class AlterProviderAgreements < ActiveRecord::Migration
  def change
  	 remove_column :provider_agreements, :status
  	 remove_column :provider_agreements, :requested_by
  	 remove_column :provider_agreements, :requested_date
  	 remove_column :provider_agreements, :approved_by
  	 remove_column :provider_agreements, :approved_date
  	 remove_column :provider_agreements, :rejected_by
  	 remove_column :provider_agreements, :rejected_date
  	 rename_column :provider_agreements, :rejection_reason, :reason
  	 add_column :provider_agreements, :state, :integer

  end
end
