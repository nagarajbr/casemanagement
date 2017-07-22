class CreateClientImmunizations < ActiveRecord::Migration
  def change
    create_table :client_immunizations do |t|
      t.references :client, index: true,null:false
      t.string :immunizations_record
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
