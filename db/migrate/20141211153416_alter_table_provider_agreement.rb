class AlterTableProviderAgreement < ActiveRecord::Migration
  def up
  	add_column :provider_agreements, :status, :integer
  end
end
