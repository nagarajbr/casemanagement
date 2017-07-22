class DropverificationdoctypeFromClientsTable < ActiveRecord::Migration
  def up
  	remove_column :clients, :verfication_doc_type
  	rename_column :clients, :verfication_date, :identification_verfication_date
  end
end
