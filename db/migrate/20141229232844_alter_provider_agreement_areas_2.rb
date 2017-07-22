class AlterProviderAgreementAreas2 < ActiveRecord::Migration
  def up
  		add_column :provider_agreement_areas, :served_local_office_id, :integer
  end
end
