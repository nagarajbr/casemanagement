class ClientsModifyOtherIdentification < ActiveRecord::Migration
  def change
  	change_column :clients, :other_identification_document, :string, limit: 50, null:true
  end
end
