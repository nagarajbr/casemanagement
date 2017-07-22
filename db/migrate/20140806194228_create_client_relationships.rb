class CreateClientRelationships < ActiveRecord::Migration
  def change
    create_table :client_relationships do |t|
      t.integer    :from_client_id,  null:false
      t.integer    :relationship_type,  null:false
      t.integer    :to_client_id,  null:false
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
