class UpdateProviderAgreementsColumn < ActiveRecord::Migration
  def change
  	rename_column :provider_agreements, :dws_local_office_manager_id, :agreement_created_by
  end
end
