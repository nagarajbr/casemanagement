class CreateClientReferrals < ActiveRecord::Migration
  def change
    create_table :client_referrals do |t|
      t.references :client, index: true,null:false
      t.references :client_barrier, index: true
      t.integer   :service_program_id
      t.date      :referral_datetime
      t.datetime  :appointment_datetime
      t.text      :appointment_contact,limit:35
      t.integer   :barrier_type
      t.text      :comments, limit:255
      t.integer :created_by , null:false
      t.integer :updated_by , null:false
      t.timestamps
    end
  end
end
