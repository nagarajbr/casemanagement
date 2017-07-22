class AlterProviderAgreementsRejectionFields < ActiveRecord::Migration
  def change
  		add_column :provider_agreements, :rejection_reason, :string
  		add_column :provider_agreements, :rejection_date, :date
  end
end
