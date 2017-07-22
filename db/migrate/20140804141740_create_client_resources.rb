class CreateClientResources < ActiveRecord::Migration
  def change
    create_table :client_resources do |t|
      t.references :client,  null:false
      t.references :resource, null:false
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
    end
  end
end
