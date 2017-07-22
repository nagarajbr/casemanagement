class AlterProviderAgreementsDropColumn < ActiveRecord::Migration
  def change
  	remove_column :provider_agreements, :rejection_date
  end
end
