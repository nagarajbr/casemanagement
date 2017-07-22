class CreateImmunizations < ActiveRecord::Migration
  def change
    create_table :immunizations do |t|
       t.references :client, index: true,null:false
       t.string :immunizations_record
       t.integer :vaccine_type
       t.integer :provider_id
       t.date :date_administered
       t.integer :created_by , null:false
       t.integer :updated_by , null:false
       t.timestamps
    end
  end
end
