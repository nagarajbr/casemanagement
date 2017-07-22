class AddColumnToClientsTable < ActiveRecord::Migration
  def up
  	 add_column :clients, :other_identification_document, :string,limit: 15
  end
end
