class UpdateColumnsInPrimaryContacts < ActiveRecord::Migration
  def change
  	change_column :primary_contacts, :created_by, :string
  	change_column :primary_contacts, :updated_by, :string
  end
end
