class AddNewColumnToProviderAgreements < ActiveRecord::Migration
  def change
  	add_column :provider_agreements, :agreement_reviewer_id, :string
  end
end
