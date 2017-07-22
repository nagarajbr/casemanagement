class AlterServiceAuthorizations7 < ActiveRecord::Migration
  def change
  	add_column :service_authorizations, :client_agreement_date, "date"
  end
end
