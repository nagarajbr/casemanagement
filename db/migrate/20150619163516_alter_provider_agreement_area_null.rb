class AlterProviderAgreementAreaNull < ActiveRecord::Migration
  def change
  	change_column :provider_agreements, :dws_local_office_id, :integer, null:true
  	change_column :provider_agreements, :dws_local_office_manager_id, :integer, null:true

  end
end
