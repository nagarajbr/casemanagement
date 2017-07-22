class AddNewColumnToSanctionsTable < ActiveRecord::Migration
  def change
  	add_column :sanctions, :compliance_office_id, :string
  end
end
