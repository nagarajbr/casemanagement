class AddColumnsToProviderAgreements < ActiveRecord::Migration
   def up
  	add_column :provider_agreements, :termination_reason, :string
  	add_column :provider_agreements, :termination_date, :date
  end

end
